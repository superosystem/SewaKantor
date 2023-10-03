package mysql_driver

import (
	"fmt"
	"github.com/superosystem/SewaKantor/backend/src/infrastructures/databases/mysql/facilities"
	"github.com/superosystem/SewaKantor/backend/src/infrastructures/databases/mysql/offices"
	"github.com/superosystem/SewaKantor/backend/src/infrastructures/databases/mysql/review"
	"github.com/superosystem/SewaKantor/backend/src/infrastructures/databases/mysql/transactions"
	"github.com/superosystem/SewaKantor/backend/src/infrastructures/databases/mysql/users"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"log"

	officeFacilities "github.com/superosystem/SewaKantor/backend/src/infrastructures/databases/mysql/office_facilities"
	officeImages "github.com/superosystem/SewaKantor/backend/src/infrastructures/databases/mysql/office_images"
)

// MySQLConfiguration holds configuration details for MySQL connection.
type MySQLConfiguration struct {
	MYSQL_HOST     string
	MYSQL_PORT     string
	MYSQL_USERNAME string
	MYSQL_PASSWORD string
	MYSQL_NAME     string
}

// ConnectMySQL establishes a connection to the MySQL database and returns the connection object.
func (config *MySQLConfiguration) ConnectMySQL() *gorm.DB {
	var err error
	location := "Asia%2FJakarta"
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=%s",
		config.MYSQL_USERNAME,
		config.MYSQL_PASSWORD,
		config.MYSQL_HOST,
		config.MYSQL_PORT,
		config.MYSQL_NAME,
		location,
	)

	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("error when connecting to database: %s", err)
	}

	log.Println("connected to database")
	return db
}

// DBMigrate performs automatic migration for specified database models.
func DBMigrate(db *gorm.DB) {
	_ = db.AutoMigrate(
		&users.User{}, &offices.Office{},
		officeImages.OfficeImage{},
		facilities.Facility{},
		officeFacilities.OfficeFacility{},
		transactions.Transaction{},
		review.Review{},
	)
}

// DisconnectMySQL closes the database connection and returns any error encountered.
func DisconnectMySQL(db *gorm.DB) error {
	database, err := db.DB()
	if err != nil {
		log.Printf("error when getting database instance: %v", err)
		return err
	}

	if err := database.Close(); err != nil {
		log.Printf("error when closing database connection: %v", err)
		return err
	}

	log.Println("database connection is closed")
	return nil
}
