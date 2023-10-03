package routes

import (
	"github.com/labstack/echo/v4"
	"github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/facilities"
	"github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/office_facilities"
	officeimage "github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/office_images"
	"github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/offices"
	"github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/review"
	"github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/transactions"
	"github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/users"

	"github.com/labstack/echo/v4/middleware"
)

type ControllerList struct {
	LoggerMiddleware         echo.MiddlewareFunc
	JWTMiddleware            middleware.JWTConfig
	AuthController           users.AuthController
	OfficeController         offices.OfficeController
	OfficeImageController    officeimage.OfficeImageController
	FacilityController       facilities.FacilityController
	OfficeFacilityController officefacilities.OfficeFacilityController
	TransactionController    transactions.TransactionController
	ReviewController         review.ReviewController
}

func (cl *ControllerList) RouteRegister(e *echo.Echo) {
	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins: []string{"*"},
		AllowHeaders: []string{
			echo.HeaderOrigin,
			echo.HeaderContentType,
			echo.HeaderAccept,
			echo.HeaderAuthorization,
			echo.HeaderServer,
		},
	}))

	e.Use(cl.LoggerMiddleware)

	e.GET("", cl.AuthController.HelloMessage)

	v1 := e.Group("/api/v1")

	// endpoint login, register, access refresh token
	v1.GET("", cl.AuthController.HelloMessage)
	v1.POST("/register", cl.AuthController.Register)
	v1.POST("/login", cl.AuthController.Login)
	v1.POST("/refresh", cl.AuthController.Token, middleware.JWTWithConfig(cl.JWTMiddleware))
	v1.POST("/logout", cl.AuthController.Logout, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "user-logout"

	// endpoint admin
	admin := v1.Group("/admin")

	// endpoint admin : manage user
	userAdmin := admin.Group("/users")
	userAdmin.GET("", cl.AuthController.GetAll, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "admin-get-all-user"
	userAdmin.GET("/:id", cl.AuthController.GetByID, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "admin-get-user-by-id"
	userAdmin.DELETE("/:id", cl.AuthController.Delete, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "admin-delete-user-account"
	userAdmin.PUT("/photo/:id", cl.AuthController.UpdateProfilePhoto, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "admin-update-user-profile-photo"
	userAdmin.PUT("/:id", cl.AuthController.UpdateProfileData, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "admin-update-user-profile-data"
	userAdmin.GET("/email", cl.AuthController.SearchByEmail, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "admin-search-user-by-email"

	// endpoint admin : manage office
	officeAdmin := admin.Group("/offices")
	officeAdmin.POST("/create", cl.OfficeController.Create, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "[admin]-create-office"
	officeAdmin.PUT("/update/:office_id", cl.OfficeController.Update, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "[admin]-update-office"
	officeAdmin.DELETE("/delete/:office_id", cl.OfficeController.Delete, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "[admin]-delete-office"
	officeAdmin.GET("/all", cl.OfficeController.GetAll, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "[admin]-get-all-type-of-offices"

	// endpoint admin : manage facilities
	facilities := admin.Group("/facilities")
	facilities.GET("/all", cl.FacilityController.GetAll, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "[admin]-get-all-facility"
	facilities.GET("/:id", cl.FacilityController.GetByID, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "[admin]-get-facility-by-id"
	facilities.POST("/create", cl.FacilityController.Create, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "[admin]-create-facility"
	facilities.PUT("/update/:id", cl.FacilityController.Update, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "[admin]-update-facility"
	facilities.DELETE("/delete/:id", cl.FacilityController.Delete, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "[admin]-delete-facility"

	// endpoint admin : manage transactions
	adminTransactions := admin.Group("/transactions")
	adminTransactionsDetail := adminTransactions.Group("/details")
	adminTransactions.GET("", cl.TransactionController.GetAll, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "[admin]-get-all-transaction"
	adminTransactionsDetail.GET("/:id", cl.TransactionController.GetByID, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "[admin]-get-transaction-by-id"
	adminTransactions.GET("/user/:user_id", cl.TransactionController.AdminGetByUserID, middleware.JWTWithConfig(cl.JWTMiddleware))
	adminTransactions.GET("/office/:office_id", cl.TransactionController.GetByOfficeID, middleware.JWTWithConfig(cl.JWTMiddleware))
	adminTransactions.GET("/total", cl.TransactionController.GetTotalTransactions, middleware.JWTWithConfig(cl.JWTMiddleware))
	adminTransactions.GET("/office/:office_id/total", cl.TransactionController.GetTotalTransactionsByOfficeID, middleware.JWTWithConfig(cl.JWTMiddleware))
	adminTransactionsDetail.POST("", cl.TransactionController.Create, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "[admin]-create-transaction"
	adminTransactionsDetail.PUT("/:id", cl.TransactionController.Update, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "[admin]-update-transaction"
	adminTransactionsDetail.DELETE("/:id", cl.TransactionController.Delete, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "[admin]delete-transaction"

	// endpoint admin : manage review
	adminReview := admin.Group("/review")
	adminReviewDetail := adminReview.Group("/details")
	adminReview.GET("", cl.ReviewController.GetAll).Name = "[admin]-get-all-review"
	adminReviewDetail.GET("/:id", cl.ReviewController.GetByID, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "[admin]-get-review-by-id"
	adminReview.GET("/user/:user_id", cl.ReviewController.AdminGetByUserID, middleware.JWTWithConfig(cl.JWTMiddleware))
	adminReviewDetail.POST("", cl.ReviewController.Create, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "[admin]-create-review"
	adminReviewDetail.PUT("/:id", cl.ReviewController.Update, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "[admin]-update-review"
	adminReviewDetail.DELETE("/:id", cl.ReviewController.Delete, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "[admin]delete-review"

	// endpoint user : profile access
	profile := v1.Group("/profile")
	profile.GET("", cl.AuthController.GetProfile, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "get-user-by-id"
	profile.DELETE("", cl.AuthController.Delete, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "delete-user-account"
	profile.PUT("/photo", cl.AuthController.UpdateProfilePhoto, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "update-user-profile-photo"
	profile.PUT("", cl.AuthController.UpdateProfileData, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "update-user-profile-data"

	// endpoint user : offices access
	offices := v1.Group("/offices")
	offices.GET("/all", cl.OfficeController.GetAll, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "get-all-type-of-offices"
	offices.GET("/:office_id", cl.OfficeController.GetByID, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "get-office-by-id"
	offices.GET("/city/:city", cl.OfficeController.SearchByCity, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "group-office-by-city"
	offices.GET("/rate/:rate", cl.OfficeController.SearchByRate, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "group-office-by-rate"
	offices.GET("/title", cl.OfficeController.SearchByTitle, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "search-office-by-title"
	offices.GET("/facilities", cl.FacilityController.GetAll, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "get-all-office-facility"
	offices.GET("/facilities/:office_id", cl.OfficeFacilityController.GetByOfficeID, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "get-office-facility-by-id"
	offices.GET("/type/office", cl.OfficeController.GetOffices, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "get-offices"
	offices.GET("/type/coworking-space", cl.OfficeController.GetCoworkingSpace, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "get-coworking-spaces"
	offices.GET("/type/meeting-room", cl.OfficeController.GetMeetingRooms, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "get-meeting-rooms"
	offices.GET("/recommendation", cl.OfficeController.GetRecommendation, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "recommendation-offices"
	offices.GET("/nearest", cl.OfficeController.GetNearest, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "get-nearest-building"

	// endpoint user : transactions access
	transactions := v1.Group("/transactions")
	transactions.GET("", cl.TransactionController.GetByUserID, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "get-user-transactions"

	transactionsDetails := transactions.Group("/details")
	transactionsDetails.GET("/:id", cl.TransactionController.GetByID, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "get-transaction-by-id"
	transactionsDetails.POST("", cl.TransactionController.Create, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "user-create-transaction"
	transactionsDetails.PUT("/:id/cancel", cl.TransactionController.Cancel, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "user-cancel-transaction"

	// endpoint user : review  access

	review := v1.Group("/review")
	review.GET("", cl.ReviewController.GetByUserID, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "get-user-review"

	reviewDetails := review.Group("/details")
	reviewDetails.GET("/:id", cl.ReviewController.GetByID, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "get-review-by-id"
	reviewDetails.POST("", cl.ReviewController.Create, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "user-create-review"
	reviewDetails.PUT("/:id", cl.ReviewController.Update, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "update-review"
	reviewDetails.GET("/office/:office_id", cl.ReviewController.GetByOfficeID, middleware.JWTWithConfig(cl.JWTMiddleware)).Name = "get-review-by-office-id"
}
