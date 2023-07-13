package response

import (
	"time"

	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
)

type HistoryResponse struct {
	ID         string
	IdBooking  string
	NikUser    string
	IdSameBook string
	Status     *string
	CreatedAt  time.Time
	UpdatedAt  time.Time
	User       model.User
}
