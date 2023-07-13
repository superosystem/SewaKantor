package faker

import (
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
	"gorm.io/gorm"
)

func HealthFacilityData(db *gorm.DB) *model.HealthFacility {
	return &model.HealthFacility{
		ID:       "1",
		Email:    "rsbunda@gmail.com",
		PhoneNum: "081222451257",
		Name:     "RS Bunda",
	}
}
