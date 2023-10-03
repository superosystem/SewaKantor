package main

import (
	"context"
	"github.com/superosystem/SewaKantor/backend/src/infrastructures/storage"
	"log"
	"net/http"
	"os"
	"os/signal"
	"sync"
	"syscall"
	"time"

	"github.com/labstack/echo/v4"
	"github.com/superosystem/SewaKantor/backend/src/applications/environment"
	"github.com/superosystem/SewaKantor/backend/src/applications/middlewares"
	_facilityUseCase "github.com/superosystem/SewaKantor/backend/src/domains/facilities"
	_officeFacilityUseCase "github.com/superosystem/SewaKantor/backend/src/domains/office_facilities"
	_officeImageUseCase "github.com/superosystem/SewaKantor/backend/src/domains/office_images"
	_officeUseCase "github.com/superosystem/SewaKantor/backend/src/domains/offices"
	_reviewUseCase "github.com/superosystem/SewaKantor/backend/src/domains/review"
	_transactionUseCase "github.com/superosystem/SewaKantor/backend/src/domains/transactions"
	_userUseCase "github.com/superosystem/SewaKantor/backend/src/domains/users"
	_driverFactory "github.com/superosystem/SewaKantor/backend/src/infrastructures/databases"
	_dbDriver "github.com/superosystem/SewaKantor/backend/src/infrastructures/databases/mysql"
	_routes "github.com/superosystem/SewaKantor/backend/src/infrastructures/http/routes"
	_facilityController "github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/facilities"
	_officeFacilityController "github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/office_facilities"
	_officeImageController "github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/office_images"
	_officeController "github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/offices"
	_reviewController "github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/review"
	_transactionController "github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/transactions"
	_userController "github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/users"
)

type operation func(context.Context) error

func main() {
	configMySQL := _dbDriver.MySQLConfiguration{
		MYSQL_HOST:     environment.GetConfig("MYSQL_HOST"),
		MYSQL_PORT:     environment.GetConfig("MYSQL_PORT"),
		MYSQL_USERNAME: environment.GetConfig("MYSQL_USERNAME"),
		MYSQL_PASSWORD: environment.GetConfig("MYSQL_PASSWORD"),
		MYSQL_NAME:     environment.GetConfig("MYSQL_NAME"),
	}

	mysqlDatabase := configMySQL.ConnectMySQL()

	_dbDriver.DBMigrate(mysqlDatabase)

	configJWT := middlewares.ConfigJWT{
		SecretJWT:       environment.GetConfig("JWT_SECRET_KEY"),
		ExpiresDuration: 1,
	}

	configLogger := middlewares.LoggerConfiguration{
		Format: "[${time_rfc3339}] ${status} ${method} ${host} ${path} ${latency_human}" + "\n",
	}

	ctx := context.Background()

	cloudStorage := storage.CloudinaryConfiguration{
		CLOUD_NAME: environment.GetConfig("CLOUDINARY_CLOUD_NAME"),
		API_KEY:    environment.GetConfig("CLOUDINARY_API_KEY"),
		SECRET_KEY: environment.GetConfig("CLOUDINARY_SECRET_KEY"),
	}

	app := echo.New()

	userRepo := _driverFactory.NewUserRepository(mysqlDatabase)
	userUseCase := _userUseCase.NewUserUsecase(userRepo, &configJWT)
	userCtrl := _userController.NewAuthController(userUseCase, cloudStorage)

	officeRepo := _driverFactory.NewOfficeRepository(mysqlDatabase)
	officeUseCase := _officeUseCase.NewOfficeUsecase(officeRepo)
	officeCtrl := _officeController.NewOfficeController(officeUseCase, cloudStorage)

	officeImageRepo := _driverFactory.NewOfficeImageRepository(mysqlDatabase)
	officeImageUseCase := _officeImageUseCase.NewOfficeImageUsecase(officeImageRepo)
	officeImageCtrl := _officeImageController.NewOfficeImageController(officeImageUseCase)

	facilityRepo := _driverFactory.NewFacilityRepository(mysqlDatabase)
	facilityUseCase := _facilityUseCase.NewFacilityUsecase(facilityRepo)
	facilityCtrl := _facilityController.NewFacilityController(facilityUseCase)

	officeFacilityRepo := _driverFactory.NewOfficeFacilityRepository(mysqlDatabase)
	officeFacilityUseCase := _officeFacilityUseCase.NewOfficeFacilityUsecase(officeFacilityRepo)
	officeFacilityCtrl := _officeFacilityController.NewOfficeFacilityController(officeFacilityUseCase)

	TransactionRepo := _driverFactory.NewTransactionRepository(mysqlDatabase)
	TransactionUseCase := _transactionUseCase.NewTransactionUsecase(TransactionRepo)
	TransactionCtrl := _transactionController.NewTransactionController(TransactionUseCase)

	reviewRepo := _driverFactory.NewReviewRepository(mysqlDatabase)
	reviewUseCase := _reviewUseCase.NewReviewUsecase(reviewRepo)
	reviewCtrl := _reviewController.NewReviewController(reviewUseCase)

	routesInit := _routes.ControllerList{
		LoggerMiddleware:         configLogger.Init(),
		JWTMiddleware:            configJWT.Init(),
		AuthController:           *userCtrl,
		OfficeController:         *officeCtrl,
		OfficeImageController:    *officeImageCtrl,
		FacilityController:       *facilityCtrl,
		OfficeFacilityController: *officeFacilityCtrl,
		TransactionController:    *TransactionCtrl,
		ReviewController:         *reviewCtrl,
	}

	routesInit.RouteRegister(app)

	go func() {
		if err := app.Start(environment.GetConfig("PORT")); err != nil && err != http.ErrServerClosed {
			app.Logger.Fatal("shutting down the server")
		}
	}()

	wait := gracefulShutdown(ctx, 5*time.Second, map[string]operation{
		"mysql": func(ctx context.Context) error {
			return _dbDriver.DisconnectMySQL(mysqlDatabase)
		},
		"http-server": func(ctx context.Context) error {
			return app.Shutdown(ctx)
		},
	})

	<-wait
}

// graceful shutdown perform application shutdown gracefully
func gracefulShutdown(ctx context.Context, timeout time.Duration, ops map[string]operation) <-chan struct{} {
	wait := make(chan struct{})

	go func() {
		s := make(chan os.Signal, 1)

		// add any other syscall that you want to be notified with
		signal.Notify(s, syscall.SIGTERM, syscall.SIGINT, syscall.SIGHUP)
		<-s

		log.Println("shutting down")

		// set timeout for the ops to be done to prevent system hang
		timeoutFunc := time.AfterFunc(timeout, func() {
			log.Printf("timeout %d ms has been elapsed, force exit", timeout.Milliseconds())
			os.Exit(0)
		})

		defer timeoutFunc.Stop()

		var wg sync.WaitGroup

		// do the operation asynchronously to save time
		for key, op := range ops {
			wg.Add(1)
			innerOp := op
			innerKey := key
			go func() {
				defer wg.Done()

				log.Printf("cleaning up: %v", innerKey)

				if err := innerOp(ctx); err != nil {
					log.Printf("%s: clean up failed: %s", innerKey, err.Error())
					return
				}

				log.Printf("%s was shutdown gracefully", innerKey)
			}()
		}

		wg.Wait()

		close(wait)
	}()

	return wait
}
