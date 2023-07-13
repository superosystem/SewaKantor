package configuration

import (
	"fmt"
	"os"

	"github.com/sirupsen/logrus"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

func InitGorm() *gorm.DB {

	host := os.Getenv("DB_HOST")
	username := os.Getenv("DB_USERNAME")
	password := os.Getenv("DB_PASSWORD")
	dbname := os.Getenv("DB_NAME")
	port := os.Getenv("DB_PORT")

	connectionString := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local",
		username,
		password,
		host,
		port,
		dbname,
	)

	db, err := gorm.Open(mysql.Open(connectionString), &gorm.Config{})
	if err != nil {
		logrus.Error("Can't connect mysql database!")
		panic(err)
	}

	logrus.Info("connected to database")

	MigrateDB(db)

	return db
}

func MigrateDB(db *gorm.DB) error {
	return db.AutoMigrate(
		model.User{},
		model.HealthFacility{},
		model.Admin{},
		model.BookingSession{},
		model.Vaccine{},
		model.Address{},
		model.Session{},
		model.VaccineHistory{},
	)
}
