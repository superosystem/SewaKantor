package response

import (
	"time"

	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
)

type UserProfile struct {
	NIK          string
	Email        string
	FullName     string
	PhoneNum     string
	Gender       string
	VaccineCount int
	BirthDate    time.Time
	Age          int
	Address      *model.Address
}
type UserHistory struct {
	NIK          string
	Email        string
	FullName     string
	PhoneNum     string
	Gender       string
	VaccineCount int
	BirthDate    time.Time
	Age          int
	Address      *model.Address
	History      []HistoryCustomUser
}

type HistoryCustomUser struct {
	ID         string
	IdBooking  string
	NikUser    string
	IdSameBook string
	Status     *string
	CreatedAt  time.Time
	UpdatedAt  time.Time
	Booking    BookingHistoryLoop
}

type BookingHistoryLoop struct {
	ID               string
	IdSession        string
	NikUser          string
	Queue            *int
	Status           *string
	CreatedAt        time.Time
	UpdatedAt        time.Time
	Session          model.Session
	HealthFacilities HealthFacilitiesCustomUser
}

type HealthFacilitiesCustomUser struct {
	ID        string
	Email     string
	PhoneNum  string
	Name      string
	Image     *string
	CreatedAt time.Time
	UpdatedAt time.Time
	Address   *model.Address
}

type AgeUser struct {
	BirthDate time.Time
	Age       int
}

type UserNearbyHealth struct {
	User             UserProfile
	HealthFacilities []HealthResponse
}

type UpdateUser struct {
	FullName  string
	NikUser   string
	Email     string
	Gender    string
	PhoneNum  string
	BirthDate time.Time
}
