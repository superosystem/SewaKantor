package model

import (
	"gorm.io/gorm"
	"time"
)

type BookingSession struct {
	ID        string  `gorm:"type:varchar(255);primary_key"`
	IdSession string  `gorm:"type:varchar(255)"`
	NikUser   string  `gorm:"type:varchar(255)"`
	Queue     int     `gorm:"type:int(11)"`
	Status    *string `gorm:"type:varchar(255)"`
	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt gorm.DeletedAt `gorm:"index"`
	Session   *Session       `gorm:"foreignKey:IdSession"` // belong to relationship
	User      User           `gorm:"foreignKey:NikUser"`
	History   VaccineHistory `gorm:"foreignKey:IdBooking"` // belong to relationship
}
