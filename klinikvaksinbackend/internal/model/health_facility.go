package model

import (
	"gorm.io/gorm"
	"time"
)

type HealthFacility struct {
	ID        string  `gorm:"type:varchar(255);primary_key"`
	Email     string  `gorm:"type:varchar(255)"`
	PhoneNum  string  `gorm:"type:varchar(255)"`
	Name      string  `gorm:"type:varchar(255)"`
	Image     *string `gorm:"type:longtext"`
	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt gorm.DeletedAt `gorm:"index"`
	Address   *Address       `gorm:"foreignKey:IdHealthFacilities"` // has one to relationship
	Vaccine   []Vaccine      `gorm:"foreignKey:IdHealthFacilities"` // has many relationship
}
