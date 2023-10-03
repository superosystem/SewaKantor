package response

import (
	"github.com/superosystem/SewaKantor/backend/src/domains/offices"

	"golang.org/x/text/cases"
	"golang.org/x/text/language"
)

type Office struct {
	ID            uint           `json:"id" form:"id" gorm:"primaryKey"`
	CreatedAt     string         `json:"created_at"`
	UpdatedAt     string         `json:"updated_at"`
	DeletedAt     string         `json:"deleted_at"`
	Title         string         `json:"title" form:"title"`
	Description   string         `json:"description" form:"description"`
	OfficeType    string         `json:"office_type" form:"office_type"`
	OfficeLength  uint           `json:"office_length" form:"office_length"`
	Price         uint           `json:"price" form:"price"`
	OpenHour      string         `json:"open_hour" form:"open_hour"`
	CloseHour     string         `json:"close_hour" form:"close_hour"`
	Lat           float64        `json:"lat" gorm:"type:decimal(10,7)" form:"lat"`
	Lng           float64        `json:"lng" gorm:"type:decimal(11,7)" form:"lng"`
	Accommodate   uint           `json:"accommodate" form:"accommodate"`
	WorkingDesk   uint           `json:"working_desk" form:"working_desk"`
	MeetingRoom   uint           `json:"meeting_room" form:"meeting_room"`
	PrivateRoom   uint           `json:"private_room" form:"private_room"`
	City          string         `json:"city" form:"city"`
	District      string         `json:"district" form:"district"`
	Address       string         `json:"address" form:"address"`
	Images        []string       `json:"images" form:"images"`
	FacilityModel []FacilityItem `json:"facility_model"`
	Distance      float64        `json:"distance" form:"distance"`
	Rate          float64        `json:"rate" form:"rate"`
	TotalBooked   int64          `json:"total_booked"`
}

func FromDomain(domain offices.Domain) Office {
	facilities := FacilitiesResponse(domain)

	return Office{
		ID:            domain.ID,
		Title:         domain.Title,
		Description:   domain.Description,
		OfficeType:    cases.Title(language.English).String(domain.OfficeType),
		OfficeLength:  domain.OfficeLength,
		Price:         domain.Price,
		OpenHour:      domain.OpenHour.Format("15:04"),
		CloseHour:     domain.CloseHour.Format("15:04"),
		Lat:           domain.Lat,
		Lng:           domain.Lng,
		Accommodate:   domain.Accommodate,
		WorkingDesk:   domain.WorkingDesk,
		MeetingRoom:   domain.MeetingRoom,
		PrivateRoom:   domain.PrivateRoom,
		FacilityModel: facilities.Items,
		City:          cases.Title(language.English).String(domain.City),
		District:      cases.Title(language.English).String(domain.District),
		Address:       cases.Title(language.English).String(domain.Address),
		Images:        domain.Images,
		Distance:      domain.Distance,
		Rate:          domain.Rate,
		TotalBooked:   domain.TotalBooked,
		CreatedAt:     domain.CreatedAt.Format("02-01-2006 15:04:05"),
		UpdatedAt:     domain.UpdatedAt.Format("02-01-2006 15:04:05"),
		DeletedAt:     domain.DeletedAt.Time.Format("01-02-2006 15:04:05"),
	}
}
