package response

import (
	"time"

	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
)

type BookingResponse struct {
	ID        string
	IdSession string
	Queue     *int
	Status    *string
	CreatedAt time.Time
	UpdatedAt time.Time
	Session   model.Session
	History   model.VaccineHistory
}
type BookingResponseCustom struct {
	ID        string
	IdSession string
	NikUser   string
	Queue     *int
	Status    *string
	CreatedAt time.Time
	UpdatedAt time.Time
	Session   BookingSessionCustom
	History   BookingHistoryCustom
}

type BookingFindQueue struct {
	ID        string
	IdSession string
	Queue     int
	Status    string
}

type BookingSessionCustom struct {
	ID           string
	IdVaccine    string
	SessionName  string
	Capacity     int
	CapacityLeft int
	Dose         int
	Date         time.Time
	IsClose      bool
	StartSession string
	EndSession   string
	CreatedAt    time.Time
	UpdatedAt    time.Time
	Vaccine      model.Vaccine
}

type BookingHistoryCustom struct {
	ID         string
	IdBooking  string
	NikUser    string
	IdSameBook string
	Status     *string
	CreatedAt  time.Time
	UpdatedAt  time.Time
	User       *model.User
}
