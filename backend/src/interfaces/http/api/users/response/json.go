package response

import (
	"github.com/superosystem/SewaKantor/backend/src/domains/users"
)

type User struct {
	ID        uint   `json:"id" gorm:"primaryKey"`
	CreatedAt string `json:"created_at"`
	UpdatedAt string `json:"updated_at"`
	DeletedAt string `json:"deleted_at"`
	FullName  string `json:"full_name"`
	Gender    string `json:"gender"`
	Email     string `json:"email"`
	Photo     string `json:"photo" form:"photo"`
}

func FromDomain(domain users.Domain) User {
	return User{
		ID:        domain.ID,
		CreatedAt: domain.CreatedAt.Format("02-01-2006 15:04:05"),
		UpdatedAt: domain.UpdatedAt.Format("02-01-2006 15:04:05"),
		DeletedAt: domain.DeletedAt.Time.Format("02-01-2006 15:04:05"),
		FullName:  domain.FullName,
		Gender:    domain.Gender,
		Email:     domain.Email,
		Photo:     domain.Photo,
	}
}
