package app

import (
	"github.com/labstack/echo/v4"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/configuration"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/controller"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/middleware"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/repository"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/routes"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/service"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/util"
	"gorm.io/gorm"

	echoSwagger "github.com/swaggo/echo-swagger"
)

func Server() *echo.Echo {
	util.ProcessEnv()

	dbConfig := configuration.InitGorm()

	// route config
	userApi := InitUserAPI(dbConfig)
	healthFacilitiesApi := InitHealthFacilitiesAPI(dbConfig)
	adminApi := InitAdminAPI(dbConfig)
	vaccineApi := InitVaccinesAPI(dbConfig)
	sessionApi := InitSessionsAPI(dbConfig)
	bookingApi := InitBookingsAPI(dbConfig)
	historyApi := InitHistoryAPI(dbConfig)

	router := echo.New()

	// middleware
	middleware.EchoCors(router)
	middleware.RemoveSlash(router)
	middleware.LogMiddleware(router)
	middleware.RecoverEcho(router)

	// v1
	// unauthenticated
	v1 := router.Group("/api/v1")

	//swagger
	router.GET("/swagger/*", echoSwagger.WrapHandler)

	// users
	routes.UserUnauthenticated(v1, userApi)
	routes.UserAuthenticated(v1, userApi)

	// health facilities
	routes.HealthFacilitiesUnauthenticated(v1, healthFacilitiesApi)
	routes.HealthFacilitiesAuthenticated(v1, healthFacilitiesApi)

	// admins
	routes.AdminUnauthenticated(v1, adminApi)
	routes.AdminAuthenticated(v1, adminApi)

	// vaccines
	routes.VaccinesUnauthenticated(v1, vaccineApi)
	routes.VaccinesAuthenticated(v1, vaccineApi)

	// sessions
	routes.SessionsUnauthenticated(v1, sessionApi)
	routes.SessionsAuthenticated(v1, sessionApi)

	// bookings
	routes.BookingsAuthenticated(v1, bookingApi)
	routes.BookingsUnauthenticated(v1, bookingApi)

	// histories
	routes.HistoriesUnauthenticated(v1, historyApi)

	return router
}

func InitUserAPI(db *gorm.DB) *controller.UserController {
	userRepo := repository.NewUserRepository(db)
	vaccinesRepo := repository.NewVaccinesRepository(db)
	historyRepo := repository.NewHistoryRepository(db)
	addressRepo := repository.NewAddressRepository(db)
	bookingsRepo := repository.NewBookingRepository(db)
	healthRepo := repository.NewHealthFacilityRepository(db)
	sessionsRepo := repository.NewSessionsRepository(db)
	userServ := service.NewUserService(userRepo, addressRepo, healthRepo, historyRepo, bookingsRepo, sessionsRepo, vaccinesRepo)
	addressServ := service.NewAddressesService(addressRepo)
	userAPI := controller.NewUserController(userServ, addressServ)
	return userAPI
}

func InitHealthFacilitiesAPI(db *gorm.DB) *controller.HealthFacilitiesController {
	healthRepo := repository.NewHealthFacilityRepository(db)
	addressRepo := repository.NewAddressRepository(db)
	adminRepo := repository.NewAdminsRepository(db)
	healthServ := service.NewHealthFacilitiesService(healthRepo, addressRepo, adminRepo)
	addressServ := service.NewAddressesService(addressRepo)
	healthAPI := controller.NewHealthFacilitiesController(healthServ, addressServ)
	return healthAPI
}

func InitAdminAPI(db *gorm.DB) *controller.AdminController {
	adminRepo := repository.NewAdminsRepository(db)
	adminServ := service.NewAdminService(adminRepo)
	adminAPI := controller.NewAdminController(adminServ)
	return adminAPI
}

func InitVaccinesAPI(db *gorm.DB) *controller.VaccinesController {
	vaccinesRepo := repository.NewVaccinesRepository(db)
	vaccinesServ := service.NewVaccinesService(vaccinesRepo)
	vaccinesAPI := controller.NewVaccinesController(vaccinesServ)
	return vaccinesAPI
}

func InitSessionsAPI(db *gorm.DB) *controller.SessionsController {
	sessionsRepo := repository.NewSessionsRepository(db)
	vaccinesRepo := repository.NewVaccinesRepository(db)
	bookingsRepo := repository.NewBookingRepository(db)
	historyRepo := repository.NewHistoryRepository(db)
	userRepo := repository.NewUserRepository(db)
	sessionsServ := service.NewSessionsService(sessionsRepo, vaccinesRepo, bookingsRepo, userRepo, historyRepo)
	sessionsAPI := controller.NewSessionsController(sessionsServ)
	return sessionsAPI
}

func InitBookingsAPI(db *gorm.DB) *controller.BookingsController {
	bookingsRepo := repository.NewBookingRepository(db)
	userRepo := repository.NewUserRepository(db)
	historyRepo := repository.NewHistoryRepository(db)
	sessionsRepo := repository.NewSessionsRepository(db)
	bookingsServ := service.NewBookingService(bookingsRepo, historyRepo, sessionsRepo, userRepo)
	bookingsAPI := controller.NewBookingController(bookingsServ)
	return bookingsAPI
}

func InitHistoryAPI(db *gorm.DB) *controller.HistoriesController {
	historyRepo := repository.NewHistoryRepository(db)
	historyServ := service.NewHistoriesService(historyRepo)
	historyAPI := controller.NewHistoriesController(historyServ)
	return historyAPI
}
