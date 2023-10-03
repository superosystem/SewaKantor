package facilities

import (
	"github.com/labstack/echo/v4"
	"github.com/superosystem/SewaKantor/backend/src/applications/middlewares"
	_utils "github.com/superosystem/SewaKantor/backend/src/commons"
	"github.com/superosystem/SewaKantor/backend/src/domains/facilities"
	ctrl "github.com/superosystem/SewaKantor/backend/src/interfaces/http/api"
	"github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/facilities/request"
	"github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/facilities/response"
	"net/http"

	"github.com/golang-jwt/jwt"
)

type FacilityController struct {
	facilityUsecase facilities.Usecase
}

func NewFacilityController(facilityUC facilities.Usecase) *FacilityController {
	return &FacilityController{
		facilityUsecase: facilityUC,
	}
}

func (oc *FacilityController) GetAll(c echo.Context) error {
	facilitiesData := oc.facilityUsecase.GetAll()

	facilities := []response.Facility{}

	for _, facility := range facilitiesData {
		facilities = append(facilities, response.FromDomain(facility))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "all facilities", facilities)
}

func (oc *FacilityController) GetByID(c echo.Context) error {
	var id = c.Param("id")

	facility := oc.facilityUsecase.GetByID(id)

	if facility.ID == 0 {
		return ctrl.NewResponse(c, http.StatusNotFound, "failed", "facility not found", "")
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "facility found", response.FromDomain(facility))
}

func (oc *FacilityController) Create(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	payload := _utils.GetPayloadInfo(c)
	role := payload.Roles

	if role != "admin" {
		return ctrl.NewInfoResponse(c, http.StatusForbidden, "forbidden", "not allowed to access this info")
	}
	inputTemp := request.Facility{}

	if err := c.Bind(&inputTemp); err != nil {
		return ctrl.NewResponse(c, http.StatusBadRequest, "failed", "validation failed", "")
	}

	input := request.Facility{
		Description: inputTemp.Description,
	}

	err := input.Validate()

	if err != nil {
		return ctrl.NewResponse(c, http.StatusBadRequest, "failed", "validation failed", "")
	}

	facility := oc.facilityUsecase.Create(input.ToDomain())

	return ctrl.NewResponse(c, http.StatusCreated, "success", "facility created", response.FromDomain(facility))
}

func (oc *FacilityController) Update(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	payload := _utils.GetPayloadInfo(c)
	role := payload.Roles

	if role != "admin" {
		return ctrl.NewInfoResponse(c, http.StatusForbidden, "forbidden", "not allowed to access this info")
	}
	input := request.Facility{}

	if err := c.Bind(&input); err != nil {
		return ctrl.NewResponse(c, http.StatusBadRequest, "failed", "validation failed", "")
	}

	var facilityId = c.Param("id")

	err := input.Validate()

	if err != nil {
		return ctrl.NewResponse(c, http.StatusBadRequest, "failed", "validation failed", "")
	}

	facility := oc.facilityUsecase.Update(facilityId, input.ToDomain())

	if facility.ID == 0 {
		return ctrl.NewResponse(c, http.StatusNotFound, "failed", "facility not found", "")
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "facility updated", response.FromDomain(facility))
}

func (oc *FacilityController) Delete(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	payload := _utils.GetPayloadInfo(c)
	role := payload.Roles

	if role != "admin" {
		return ctrl.NewInfoResponse(c, http.StatusForbidden, "forbidden", "not allowed to access this info")
	}
	var facilityId = c.Param("id")

	isSuccess := oc.facilityUsecase.Delete(facilityId)

	if !isSuccess {
		return ctrl.NewResponse(c, http.StatusNotFound, "failed", "facility not found", "")
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "facility deleted", "")
}
