package routes

import (
	"os"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/controller"
)

func AdminUnauthenticated(routes *echo.Group, api *controller.AdminController) {
	{
		routes.POST("/admin/login", api.LoginAdmin)
	}
}

func AdminAuthenticated(routes *echo.Group, api *controller.AdminController) {
	authAdmin := routes.Group("/admin")
	authAdmin.Use(middleware.JWT([]byte(os.Getenv("SECRET_JWT_KEY_ADMIN"))))
	{
		authAdmin.GET("/profile", api.GetAdmin)
		authAdmin.GET("/all", api.GetAllAdmins)
		authAdmin.PUT("/profile", api.UpdateAdmin)
		authAdmin.DELETE("/profile/:id", api.DeleteAdmin)
	}
}
