package routes

import (
	"os"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/controller"
)

func HealthFacilitiesUnauthenticated(routes *echo.Group, api *controller.HealthFacilitiesController) {
	{
		routes.GET("/healthfacilities", api.GetAllHealthFacilities)
		routes.GET("/healthfacilities/:name", api.GetHealthFacilities)
		routes.POST("/healthfacilities", api.CreateHealthFacilities)
	}
}

func HealthFacilitiesAuthenticated(routes *echo.Group, api *controller.HealthFacilitiesController) {
	authAdmin := routes.Group("/admin")
	authAdmin.Use(middleware.JWT([]byte(os.Getenv("SECRET_JWT_KEY_ADMIN"))))
	{
		authAdmin.PUT("/healthfacilities", api.UpdateHealthFacilities)
		authAdmin.DELETE("/healthfacilities/:id", api.DeleteHealthFacilities)
	}
}
