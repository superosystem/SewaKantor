package officefacilities

import (
	"github.com/labstack/echo/v4"
	"github.com/superosystem/SewaKantor/backend/src/domains/office_facilities"
	ctrl "github.com/superosystem/SewaKantor/backend/src/interfaces/http/api"
	"github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/office_facilities/request"
	"github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/office_facilities/response"
	"net/http"
)

type OfficeFacilityController struct {
	officeFacilityUsecase officefacilities.Usecase
}

func NewOfficeFacilityController(fc officefacilities.Usecase) *OfficeFacilityController {
	return &OfficeFacilityController{
		officeFacilityUsecase: fc,
	}
}

func (oc *OfficeFacilityController) GetAll(c echo.Context) error {
	officeFacilitiesData := oc.officeFacilityUsecase.GetAll()

	officeFacilities := []response.OfficeFacility{}

	for _, ofac := range officeFacilitiesData {
		officeFacilities = append(officeFacilities, response.FromDomain(ofac))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "all facilities", officeFacilities)
}

func (oc *OfficeFacilityController) GetByOfficeID(c echo.Context) error {
	officeId := c.Param("office_id")

	oFacData := oc.officeFacilityUsecase.GetByOfficeID(officeId)

	oFac := []response.OfficeFacility{}

	for _, ofac := range oFacData {
		oFac = append(oFac, response.FromDomain(ofac))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "get all office facilities by office_id", oFac)
}

func (oc *OfficeFacilityController) Create(c echo.Context) error {
	input := request.OfficeFacility{}

	if err := c.Bind(&input); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "validation failed")
	}

	err := input.Validate()

	if err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "validation failed")
	}

	oFac := oc.officeFacilityUsecase.Create(input.ToDomain())

	if oFac.ID == 0 {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "create failed")
	}

	return ctrl.NewResponse(c, http.StatusCreated, "success", "office facility created", response.FromDomain(oFac))
}
