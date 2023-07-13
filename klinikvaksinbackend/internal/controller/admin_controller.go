package controller

import (
	"net/http"

	"github.com/golang-jwt/jwt"
	"github.com/labstack/echo/v4"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/dto/payload"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/service"
)

type AdminController struct {
	AdminServ service.AdminService
}

func NewAdminController(adminServ service.AdminService) *AdminController {
	return &AdminController{
		AdminServ: adminServ,
	}
}

func (a *AdminController) LoginAdmin(ctx echo.Context) error {
	var payloads payload.Login

	if err := ctx.Bind(&payloads); err != nil {
		return ctx.JSON(http.StatusBadRequest, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	authAdmin, err := a.AdminServ.LoginAdmin(payloads)

	if err != nil {
		return ctx.JSON(http.StatusUnauthorized, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	return ctx.JSON(http.StatusOK, map[string]interface{}{
		"error":   false,
		"message": "success login admin",
		"data":    authAdmin,
	})
}

func (a *AdminController) GetAdmin(ctx echo.Context) error {
	admin := ctx.Get("user").(*jwt.Token)
	claimId := admin.Claims.(jwt.MapClaims)
	id := claimId["Id"].(string)

	data, err := a.AdminServ.GetAdmin(id)

	if err != nil {
		return ctx.JSON(http.StatusInternalServerError, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	return ctx.JSON(http.StatusOK, map[string]interface{}{
		"error":   false,
		"message": "success get admin",
		"data":    data,
	})
}

func (a *AdminController) GetAllAdmins(ctx echo.Context) error {
	data, err := a.AdminServ.GetAllAdmins()

	if err != nil {
		return ctx.JSON(http.StatusInternalServerError, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	return ctx.JSON(http.StatusOK, map[string]interface{}{
		"error":   false,
		"message": "success get all admin",
		"data":    data,
	})
}

func (a *AdminController) UpdateAdmin(ctx echo.Context) error {
	var payloads payload.AdminPayload

	admin := ctx.Get("user").(*jwt.Token)
	claimId := admin.Claims.(jwt.MapClaims)
	id := claimId["Id"].(string)

	if err := ctx.Bind(&payloads); err != nil {
		return ctx.JSON(http.StatusBadRequest, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	data, err := a.AdminServ.UpdateAdmin(payloads, id)
	if err != nil {
		return ctx.JSON(http.StatusInternalServerError, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	return ctx.JSON(http.StatusOK, map[string]interface{}{
		"error":   false,
		"message": "success update admin",
		"data":    data,
	})
}

func (a *AdminController) DeleteAdmin(ctx echo.Context) error {
	id := ctx.Param("id")

	if err := a.AdminServ.DeleteAdmin(id); err != nil {
		return ctx.JSON(http.StatusInternalServerError, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	return ctx.JSON(http.StatusOK, map[string]interface{}{
		"error":   false,
		"message": "success delete admin",
	})
}
