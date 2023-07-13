package routes

import (
	"os"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/controller"
)

func UserUnauthenticated(routes *echo.Group, api *controller.UserController) {
	{
		routes.POST("/signup", api.RegisterUser)
		routes.POST("/login", api.LoginUser)
		routes.GET("/dashboard/statistics/users", api.GetUserRegisteredDashboard)
	}
}

func UserAuthenticated(routes *echo.Group, api *controller.UserController) {
	authUser := routes.Group("/profile")
	authUser.Use(middleware.JWT([]byte(os.Getenv("SECRET_JWT_KEY"))))
	{
		authUser.GET("", api.GetUserDataByNik)
		authUser.GET("/history", api.GetUserHistoryByNikCheck)
		authUser.GET("/address", api.GetUserAddress)
		authUser.GET("/check/:nik", api.GetUserDataByNikCheck)
		authUser.PUT("", api.UpdateUser)
		authUser.DELETE("", api.DeleteUser)
		authUser.PUT("/address", api.UpdateUserAddress)
		authUser.POST("/nearby", api.UserNearbyHealth)
	}
}
