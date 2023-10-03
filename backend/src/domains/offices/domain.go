package offices

import (
	"gorm.io/gorm"
	"time"
)

type Domain struct {
	ID             uint
	Title          string
	Description    string
	OfficeType     string
	OfficeLength   uint
	Price          uint
	OpenHour       time.Time
	CloseHour      time.Time
	Lat            float64
	Lng            float64
	Accommodate    uint
	WorkingDesk    uint
	MeetingRoom    uint
	PrivateRoom    uint
	City           string
	District       string
	Address        string
	Images         []string
	FacilitiesId   []string
	FacilitiesDesc []string
	FacilitesSlug  []string
	Distance       float64
	Rate           float64
	TotalBooked    int64
	CreatedAt      time.Time
	UpdatedAt      time.Time
	DeletedAt      gorm.DeletedAt
}

type Usecase interface {
	GetAll() []Domain
	GetByID(id string) Domain
	Create(officeDomain *Domain) Domain
	Update(id string, officeDomain *Domain) Domain
	Delete(id string) bool
	SearchByCity(city string) []Domain
	SearchByRate(rate string) []Domain
	SearchByTitle(title string) Domain
	GetOffices() []Domain
	GetCoworkingSpace() []Domain
	GetMeetingRooms() []Domain
	GetRecommendation() []Domain
	GetNearest(lat string, long string) []Domain
}

type Repository interface {
	GetAll() []Domain
	GetByID(id string) Domain
	Create(officeDomain *Domain) Domain
	Update(id string, officeDomain *Domain) Domain
	Delete(id string) bool
	GetNearest(lat string, long string) []Domain
}
