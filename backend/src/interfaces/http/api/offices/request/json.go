package request

import (
	"github.com/go-playground/validator/v10"
	"github.com/superosystem/SewaKantor/backend/src/commons"
	"github.com/superosystem/SewaKantor/backend/src/domains/offices"
	"time"
)

type Office struct {
	Title        string `json:"title" form:"title" validate:"required"`
	Description  string `json:"description" form:"description" validate:"required"`
	OfficeType   string `json:"office_type" form:"office_type" validate:"required,oneof='office' 'coworking space' 'meeting room'"`
	OfficeLength uint   `json:"office_length" form:"office_length" validate:"required,numeric"`
	Price        uint   `json:"price" form:"price" validate:"required,numeric"`
	OpenHour     time.Time
	CloseHour    time.Time
	Lat          float64  `json:"lat" form:"lat" validate:"required,latitude,min=-90,max=90"`
	Lng          float64  `json:"lng" form:"lng" validate:"required,longitude,min=-180,max=180"`
	Accommodate  uint     `json:"accommodate" form:"accommodate" validate:"required,numeric"`
	WorkingDesk  uint     `json:"working_desk" form:"working_desk" validate:"required,numeric"`
	MeetingRoom  uint     `json:"meeting_room" form:"meeting_room" validate:"required,numeric"`
	PrivateRoom  uint     `json:"private_room" form:"private_room" validate:"required,numeric"`
	City         string   `json:"city" form:"city" validate:"required,oneof='central jakarta' 'south jakarta' 'west jakarta' 'east jakarta' 'thousand islands'"`
	District     string   `json:"district" form:"district" validate:"required"`
	Address      string   `json:"address" form:"address" validate:"required"`
	Images       []string `json:"images" form:"images"`
	FacilitiesId []string `json:"facilities_id" validate:"required"`
	Rate         float64  `json:"rate"`
}

type HourDTO struct {
	OpenHour  string `json:"open_hour" form:"open_hour" validate:"required"`
	CloseHour string `json:"close_hour" form:"close_hour" validate:"required"`
}

type FacilitiesIdDTO struct {
	Id string `json:"facilities_id" form:"facilities_id" validate:"required"`
}

type GeoLocationDTO struct {
	Lat float64 `json:"lat" form:"lat" validate:"required,latitude,min=-90,max=90"`
	Lng float64 `json:"lng" form:"lng" validate:"required,longitude,min=-180,max=180"`
}

func (req *Office) ToDomain() *offices.Domain {
	return &offices.Domain{
		Title:        req.Title,
		Description:  req.Description,
		OfficeType:   req.OfficeType,
		OfficeLength: req.OfficeLength,
		Price:        req.Price,
		OpenHour:     req.OpenHour,
		CloseHour:    req.CloseHour,
		Lat:          req.Lat,
		Lng:          req.Lng,
		Accommodate:  req.Accommodate,
		WorkingDesk:  req.WorkingDesk,
		MeetingRoom:  req.MeetingRoom,
		PrivateRoom:  req.PrivateRoom,
		City:         req.City,
		District:     req.District,
		Address:      req.Address,
		Images:       req.Images,
		FacilitiesId: req.FacilitiesId,
		Rate:         req.Rate,
	}
}

func (req *Office) Validate() error {
	validate := validator.New()

	err := validate.Struct(req)

	return err
}

func (req *GeoLocationDTO) Validate() error {
	validate := validator.New()

	err := validate.Struct(req)

	return err
}

func (req *HourDTO) Validate() error {
	err := commons.IsValidTime(req.OpenHour)

	if err != nil {
		return err
	}

	err = commons.IsValidTime(req.CloseHour)

	if err != nil {
		return err
	}

	return err
}
