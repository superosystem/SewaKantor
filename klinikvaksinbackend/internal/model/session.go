package model

import "time"

type Session struct {
	ID           string    `gorm:"type:varchar(255);primary_key"`
	IdVaccine    string    `gorm:"type:varchar(255)"`
	SessionName  string    `gorm:"type:varchar(255)"`
	Capacity     int       `gorm:"type:int(11)"`
	Dose         int       `gorm:"type:int(1)"`
	Date         time.Time `gorm:"type:date"`
	IsClose      bool      `gorm:"type:boolean"`
	StartSession string    `gorm:"type:varchar(5)"`
	EndSession   string    `gorm:"type:varchar(5)"`
	CreatedAt    time.Time
	UpdatedAt    time.Time
	Vaccine      Vaccine          `gorm:"foreignKey:IdVaccine"`
	Booking      []BookingSession `gorm:"foreignKey:IdSession"`
}
