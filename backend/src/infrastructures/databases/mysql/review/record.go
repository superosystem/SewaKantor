package review

import (
	reviewUseCase "github.com/superosystem/SewaKantor/backend/src/domains/review"
	"github.com/superosystem/SewaKantor/backend/src/infrastructures/databases/mysql/offices"
	"github.com/superosystem/SewaKantor/backend/src/infrastructures/databases/mysql/users"
	"time"

	"gorm.io/gorm"
)

type Review struct {
	ID        uint           `json:"id" gorm:"primaryKey"`
	Score     float64        `json:"score"`
	Comment   string         `json:"comment"`
	UserID    uint           `json:"user_id"`
	OfficeID  uint           `json:"office_id"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"deleted_at"`
	User      users.User     `json:"user" gorm:"foreignKey:UserID;references:ID"`
	Office    offices.Office `json:"office" gorm:"foreignKey:OfficeID;references:ID"`
}

func FromDomain(domain *reviewUseCase.Domain) *Review {
	return &Review{
		ID:        domain.ID,
		Score:     domain.Score,
		Comment:   domain.Comment,
		UserID:    domain.UserID,
		OfficeID:  domain.OfficeID,
		CreatedAt: domain.CreatedAt,
		UpdatedAt: domain.UpdatedAt,
		DeletedAt: domain.DeletedAt,
	}
}

func (rec *Review) ToDomain() reviewUseCase.Domain {
	return reviewUseCase.Domain{
		ID:           rec.ID,
		Score:        rec.Score,
		Comment:      rec.Comment,
		UserFullName: rec.User.FullName,
		UserEmail:    rec.User.Email,
		UserID:       rec.User.ID,
		OfficeName:   rec.Office.Title,
		OfficeType:   rec.Office.OfficeType,
		OfficeID:     rec.OfficeID,
		CreatedAt:    rec.CreatedAt,
		UpdatedAt:    rec.UpdatedAt,
		DeletedAt:    rec.DeletedAt,
	}
}
