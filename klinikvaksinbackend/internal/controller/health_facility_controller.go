package controller

import (
	"net/http"
	"strings"

	"github.com/golang-jwt/jwt"
	"github.com/labstack/echo/v4"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/dto/payload"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/service"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/util"
)

type HealthFacilitiesController struct {
	HealthService  service.HealthFacilitiesService
	AddressService service.AddressService
}

func NewHealthFacilitiesController(healthServ service.HealthFacilitiesService, addressServ service.AddressService) *HealthFacilitiesController {
	return &HealthFacilitiesController{
		HealthService:  healthServ,
		AddressService: addressServ,
	}
}

func (h *HealthFacilitiesController) CreateHealthFacilities(ctx echo.Context) error {
	var payloads payload.HealthFacility

	if err := ctx.Bind(&payloads); err != nil {
		return ctx.JSON(http.StatusBadRequest, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	if err := util.Validate(payloads); err != nil {
		return ctx.JSON(http.StatusBadRequest, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	err := h.HealthService.CreateHealthFacilities(payloads)

	if err != nil {
		return ctx.JSON(http.StatusInternalServerError, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	return ctx.JSON(http.StatusCreated, map[string]interface{}{
		"error":    false,
		"messages": "success create health facilities",
	})
}

func (h *HealthFacilitiesController) GetHealthFacilities(ctx echo.Context) error {
	name := ctx.Param("name")
	nameLower := strings.ToLower(name)
	data, err := h.HealthService.GetHealthFacilities(nameLower)

	if err != nil {
		return ctx.JSON(http.StatusInternalServerError, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	return ctx.JSON(http.StatusOK, map[string]interface{}{
		"error":   false,
		"message": "success get health facilities",
		"data":    data,
	})
}

func (h *HealthFacilitiesController) GetAllHealthFacilities(ctx echo.Context) error {
	data, err := h.HealthService.GetAllHealthFacilities()
	if err != nil {
		return ctx.JSON(http.StatusInternalServerError, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	return ctx.JSON(http.StatusOK, map[string]interface{}{
		"error":   false,
		"message": "success get all health facilites",
		"data":    data,
	})
}

func (h *HealthFacilitiesController) UpdateHealthFacilities(ctx echo.Context) error {
	var payloads payload.UpdateHealthFacility

	admin := ctx.Get("user").(*jwt.Token)
	claimId := admin.Claims.(jwt.MapClaims)
	id := claimId["IdHealthFacilities"].(string)

	if err := ctx.Bind(&payloads); err != nil {
		return ctx.JSON(http.StatusBadRequest, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	data, err := h.HealthService.UpdateHealthFacilities(payloads, id)
	if err != nil {
		return ctx.JSON(http.StatusBadRequest, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	return ctx.JSON(http.StatusOK, map[string]interface{}{
		"error":   false,
		"message": "success update health facilities",
		"data":    data,
	})
}

func (h *HealthFacilitiesController) DeleteHealthFacilities(ctx echo.Context) error {
	id := ctx.Param("id")

	if err := h.HealthService.DeleteHealthFacilities(id); err != nil {
		return ctx.JSON(http.StatusInternalServerError, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	return ctx.JSON(http.StatusOK, map[string]interface{}{
		"error":   false,
		"message": "success delete health facilities",
	})
}
