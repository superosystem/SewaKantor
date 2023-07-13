package faker

import (
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/util"
	"gorm.io/gorm"
)

func AdminData(db *gorm.DB) *model.Admin {
	hashPass, _ := util.HashPassword("Admin12345")

	return &model.Admin{
		ID:                 "1",
		IdHealthFacilities: "1",
		Email:              "admin@rsbunda.com",
		Password:           hashPass,
	}
}
