package main

import (
	"github.com/sirupsen/logrus"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/cmd/seeder/faker"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/configuration"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/util"

	"gorm.io/gorm"
)

type Seed struct {
	Seeder interface{}
}

func registerDataSeed(db *gorm.DB) []Seed {
	return []Seed{
		{Seeder: faker.HealthFacilityData(db)},
		{Seeder: faker.AdminData(db)},
	}
}

func main() {
	util.ProcessEnv()
	dbConfig := configuration.InitGorm()
	for _, data := range registerDataSeed(dbConfig) {
		err := dbConfig.Debug().Create(data.Seeder).Error
		if err != nil {
			logrus.Fatal("Failed to run seeder")
		}
		logrus.Info("Success, Run seeder")
	}
	logrus.Info("Execute Seeder")
}
