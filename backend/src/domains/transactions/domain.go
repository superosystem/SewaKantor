package transactions

import (
	"gorm.io/gorm"
	"time"
)

type Domain struct {
	ID            uint
	Price         uint
	CheckIn       time.Time
	CheckOut      time.Time
	Duration      int
	PaymentMethod string
	Status        string
	Drink         string
	UserID        uint
	UserFullName  string
	UserEmail     string
	OfficeID      uint
	OfficeName    string
	OfficeType    string
	CreatedAt     time.Time
	UpdatedAt     time.Time
	DeletedAt     gorm.DeletedAt
}

type Usecase interface {
	GetAll() []Domain
	GetByUserID(userId string) []Domain
	AdminGetByUserID(userId string) []Domain
	GetByOfficeID(officeId string) []Domain
	Create(transactionDomain *Domain) Domain
	GetByID(id string) Domain
	Update(id string, status string) Domain
	Delete(id string) bool
	Cancel(transactionId string, userId string) Domain
	TotalTransactions() int
	TotalTransactionsByOfficeID(officeId string) int
}

type Repository interface {
	GetAll() []Domain
	GetByUserID(userId string) []Domain
	GetByOfficeID(officeId string) []Domain
	Create(transactionDomain *Domain) Domain
	GetByID(id string) Domain
	Update(id string, transactionDomain *Domain) Domain
	Delete(id string) bool
	TotalTransactions() int
	TotalTransactionsByOfficeID(officeId string) int
}
