package response

import (
	"github.com/superosystem/SewaKantor/backend/src/domains/review"

	"gorm.io/gorm"
)

type user struct {
	UserID   uint   `json:"user_id"`
	FullName string `json:"full_name"`
	Email    string `json:"email"`
}

type office struct {
	OfficeID   uint   `json:"office_id"`
	OfficeName string `json:"office_name"`
	OfficeType string `json:"office_type"`
}

type Review struct {
	ID        uint           `json:"id"`
	CreatedAt string         `json:"created_at"`
	UpdatedAt string         `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"deleted_at"`
	Comment   string         `json:"comment"`
	Score     float64        `json:"score"`
	User      user           `json:"user"`
	Office    office         `json:"office"`
}

func FromDomain(domain review.Domain) Review {
	return Review{
		ID:        domain.ID,
		CreatedAt: domain.CreatedAt.Format("02-01-2006 15:04:05"),
		UpdatedAt: domain.UpdatedAt.Format("02-01-2006 15:04:05"),
		DeletedAt: domain.DeletedAt,
		Comment:   domain.Comment,
		Score:     domain.Score,
		User: user{
			UserID:   domain.UserID,
			FullName: domain.UserFullName,
			Email:    domain.UserEmail,
		},
		Office: office{
			OfficeID:   domain.OfficeID,
			OfficeName: domain.OfficeName,
			OfficeType: domain.OfficeType,
		},
	}
}
