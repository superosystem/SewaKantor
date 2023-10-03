package request

import (
	"github.com/go-playground/validator/v10"
	"github.com/superosystem/SewaKantor/backend/src/domains/review"
)

type Review struct {
	Comment  string  `json:"comment" form:"comment" validate:"required"`
	Score    float64 `json:"score" form:"score" validate:"required"`
	UserID   uint    `json:"user_id" form:"user_id" validate:"required"`
	OfficeID uint    `json:"office_id" form:"office_id" validate:"required"`
}

func (req *Review) ToDomain() *review.Domain {
	return &review.Domain{
		Comment:  req.Comment,
		Score:    req.Score,
		UserID:   req.UserID,
		OfficeID: req.OfficeID,
	}
}

func (req *Review) Validate() error {
	validate := validator.New()

	err := validate.Struct(req)

	return err
}
