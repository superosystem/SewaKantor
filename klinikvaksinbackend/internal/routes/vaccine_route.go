package routes

import (
	"os"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/controller"
)

func VaccinesUnauthenticated(routes *echo.Group, api *controller.VaccinesController) {
	{
		routes.GET("/vaccines", api.GetAllVaccines)
		routes.GET("/dashboard/vaccines", api.GetVaccineDashboard)
		routes.GET("/dashboard/vaccines/amount", api.GetAllVaccinesCount)
	}
}

func VaccinesAuthenticated(routes *echo.Group, api *controller.VaccinesController) {
	authAdmin := routes.Group("/admin")
	authAdmin.Use(middleware.JWT([]byte(os.Getenv("SECRET_JWT_KEY_ADMIN"))))
	{
		authAdmin.POST("/vaccines", api.CreateVaccine)
		authAdmin.GET("/vaccines", api.GetVaccineByAdmin)
		authAdmin.PUT("/vaccines/:id", api.UpdateVaccine)
		authAdmin.DELETE("/vaccines/:id", api.DeleteVacccine)
	}
}
