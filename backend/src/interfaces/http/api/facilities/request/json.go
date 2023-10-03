package request

import (
	"github.com/go-playground/validator/v10"
	"github.com/superosystem/SewaKantor/backend/src/domains/facilities"
)

type Facility struct {
	Description string `json:"description" form:"description" validate:"required"`
}

func (req *Facility) ToDomain() *facilities.Domain {
	return &facilities.Domain{
		Description: req.Description,
	}
}

func (req *Facility) Validate() error {
	validate := validator.New()

	err := validate.Struct(req)

	return err
}
