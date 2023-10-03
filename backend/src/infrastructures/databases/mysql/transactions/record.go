package transactions

import (
	transactionUseCase "github.com/superosystem/SewaKantor/backend/src/domains/transactions"
	"github.com/superosystem/SewaKantor/backend/src/infrastructures/databases/mysql/offices"
	"github.com/superosystem/SewaKantor/backend/src/infrastructures/databases/mysql/users"
	"time"

	"gorm.io/gorm"
)

type Transaction struct {
	ID            uint           `json:"id" gorm:"primaryKey"`
	Price         uint           `json:"price"`
	CheckIn       time.Time      `json:"check_in" gorm:"type:timestamp;not null;default:now()"`
	CheckOut      time.Time      `json:"check_out" gorm:"type:timestamp;not null;default:now()"`
	Duration      int            `json:"duration" form:"duration"`
	Status        string         `gorm:"type:enum('pending','on process','accepted','cancelled','rejected')" json:"status"`
	Drink         string         `json:"drink"`
	PaymentMethod string         `json:"payment_method"`
	UserID        uint           `json:"user_id"`
	OfficeID      uint           `json:"office_id"`
	User          users.User     `json:"user" gorm:"foreignKey:UserID;references:ID"`
	Office        offices.Office `json:"office" gorm:"foreignKey:OfficeID;references:ID"`
	CreatedAt     time.Time      `json:"created_at"`
	UpdatedAt     time.Time      `json:"updated_at"`
	DeletedAt     gorm.DeletedAt `json:"deleted_at"`
}

func FromDomain(domain *transactionUseCase.Domain) *Transaction {
	return &Transaction{
		ID:            domain.ID,
		Price:         domain.Price,
		CheckIn:       domain.CheckIn,
		Duration:      domain.Duration,
		CheckOut:      domain.CheckOut,
		PaymentMethod: domain.PaymentMethod,
		Status:        domain.Status,
		Drink:         domain.Drink,
		UserID:        domain.UserID,
		OfficeID:      domain.OfficeID,
		CreatedAt:     domain.CreatedAt,
		UpdatedAt:     domain.UpdatedAt,
		DeletedAt:     domain.DeletedAt,
	}
}

func (rec *Transaction) ToDomain() transactionUseCase.Domain {
	return transactionUseCase.Domain{
		ID:            rec.ID,
		Price:         rec.Price,
		CheckIn:       rec.CheckIn,
		Duration:      rec.Duration,
		CheckOut:      rec.CheckOut,
		PaymentMethod: rec.PaymentMethod,
		Status:        rec.Status,
		Drink:         rec.Drink,
		UserFullName:  rec.User.FullName,
		UserEmail:     rec.User.Email,
		UserID:        rec.UserID,
		OfficeName:    rec.Office.Title,
		OfficeType:    rec.Office.OfficeType,
		OfficeID:      rec.OfficeID,
		CreatedAt:     rec.CreatedAt,
		UpdatedAt:     rec.UpdatedAt,
		DeletedAt:     rec.DeletedAt,
	}
}
