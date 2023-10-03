package officeimages

import (
	"github.com/labstack/echo/v4"
	"github.com/superosystem/SewaKantor/backend/src/domains/office_images"
	ctrl "github.com/superosystem/SewaKantor/backend/src/interfaces/http/api"
	"github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/office_images/request"
	"github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/office_images/response"
	"net/http"
)

type OfficeImageController struct {
	officeImageUsecase officeimages.Usecase
}

func NewOfficeImageController(uc officeimages.Usecase) *OfficeImageController {
	return &OfficeImageController{
		officeImageUsecase: uc,
	}
}

func (oc *OfficeImageController) GetByOfficeID(c echo.Context) error {
	officeId := c.Param("office_id")

	officeImagesData := oc.officeImageUsecase.GetByOfficeID(officeId)

	officeImages := []response.OfficeImage{}

	for _, v := range officeImagesData {
		officeImages = append(officeImages, response.FromDomain(v))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "get all office images by office_id", officeImages)
}

func (oc *OfficeImageController) Create(c echo.Context) error {
	input := request.OfficeImage{}

	if err := c.Bind(&input); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "validation failed")
	}

	err := input.Validate()

	if err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "validation failed")
	}

	imgUrls := oc.officeImageUsecase.Create(input.ToDomain())

	if imgUrls.ID == 0 {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "create failed")
	}

	return ctrl.NewResponse(c, http.StatusCreated, "success", "office image url created", response.FromDomain(imgUrls))
}
