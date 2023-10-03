package review

import (
	"gorm.io/gorm"
	"time"
)

type Domain struct {
	ID           uint
	Comment      string
	Score        float64
	UserID       uint
	UserFullName string
	UserEmail    string
	OfficeID     uint
	OfficeName   string
	OfficeType   string
	CreatedAt    time.Time
	UpdatedAt    time.Time
	DeletedAt    gorm.DeletedAt
}

type Usecase interface {
	GetAll() []Domain
	Create(reviewDomain *Domain) Domain
	GetByID(id string) Domain
	Update(id string, reviewDomain *Domain) Domain
	Delete(id string) bool
	GetByUserID(userId string) []Domain
	AdminGetByUserID(userId string) []Domain
	GetByOfficeID(officeId string) []Domain
}

type Repository interface {
	GetAll() []Domain
	Create(reviewDomain *Domain) Domain
	GetByID(id string) Domain
	Update(id string, reviewDomain *Domain) Domain
	Delete(id string) bool
	GetByUserID(userId string) []Domain
	GetByOfficeID(officeId string) []Domain
}
