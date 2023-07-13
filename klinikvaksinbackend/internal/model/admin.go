package model

import (
	"gorm.io/gorm"
	"time"
)

type Admin struct {
	ID                 string `gorm:"type:varchar(255);primary_key"`
	IdHealthFacilities string `gorm:"type:varchar(255)"`
	Email              string `gorm:"type:varchar(255)"`
	Password           string `gorm:"type:varchar(255)"`
	CreatedAt          time.Time
	UpdatedAt          time.Time
	DeletedAt          gorm.DeletedAt  `gorm:"index"`
	HealthFacility     *HealthFacility `gorm:"foreignKey:IdHealthFacilities"` // belong to relationship
}
