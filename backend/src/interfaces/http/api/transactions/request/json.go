package request

import (
	"github.com/go-playground/validator/v10"
	"github.com/superosystem/SewaKantor/backend/src/commons"
	"github.com/superosystem/SewaKantor/backend/src/domains/transactions"
	"time"
)

type Transaction struct {
	Price         uint `json:"price" form:"price" validate:"required"`
	UserID        uint `json:"user_id" form:"user_id" validate:"required"`
	CheckIn       time.Time
	Drink         string `json:"drink" form:"drink" validate:"required"`
	Status        string `json:"status" form:"status" validate:"omitempty"`
	Duration      int    `json:"duration" form:"duration" validate:"required"`
	PaymentMethod string `json:"payment_method" form:"payment_method" validate:"required"`
	OfficeID      uint   `json:"office_id" form:"office_id" validate:"required"`
}

type CheckInDTO struct {
	CheckInHour string `json:"check_in_hour" form:"check_in_hour" validate:"required"`
	CheckInDate string `json:"check_in_date" form:"check_in_date" validate:"required"`
}

type StatusDTO struct {
	Status string `json:"status" form:"status"`
}

func (req *Transaction) ToDomain() *transactions.Domain {
	return &transactions.Domain{
		Price:         req.Price,
		CheckIn:       req.CheckIn,
		Duration:      req.Duration,
		Drink:         req.Drink,
		Status:        req.Status,
		PaymentMethod: req.PaymentMethod,
		UserID:        req.UserID,
		OfficeID:      req.OfficeID,
	}
}

func (req *Transaction) Validate() error {
	validate := validator.New()

	err := commons.StatusValidation(req.Status)

	if err != nil {
		return err
	}

	err = validate.Struct(req)

	return err
}

func (req *CheckInDTO) Validate() error {
	err := commons.IsValidTime(req.CheckInHour)

	if err != nil {
		return err
	}

	err = commons.DateValidation(req.CheckInDate)

	return err
}

func (req *StatusDTO) Validate() error {
	var err error

	if err = commons.StatusValidation(req.Status); err != nil {
		return err
	}

	return err
}
