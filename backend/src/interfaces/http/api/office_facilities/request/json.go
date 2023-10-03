package request

import (
	"github.com/go-playground/validator/v10"
	"github.com/superosystem/SewaKantor/backend/src/domains/office_facilities"
)

type OfficeFacility struct {
	FacilitiesID uint `json:"facilities_id" form:"facilities_id" validate:"required"`
	OfficeID     uint `json:"office_id" form:"office_id" validate:"required"`
}

func (req *OfficeFacility) ToDomain() *officefacilities.Domain {
	return &officefacilities.Domain{
		FacilitiesID: req.FacilitiesID,
		OfficeID:     req.OfficeID,
	}
}

func (req *OfficeFacility) Validate() error {
	validate := validator.New()

	err := validate.Struct(req)

	return err
}
