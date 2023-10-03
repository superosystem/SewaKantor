package databases

import (
	facilityDomain "github.com/superosystem/SewaKantor/backend/src/domains/facilities"
	officeFacilityDomain "github.com/superosystem/SewaKantor/backend/src/domains/office_facilities"
	officeImageDomain "github.com/superosystem/SewaKantor/backend/src/domains/office_images"
	officeDomain "github.com/superosystem/SewaKantor/backend/src/domains/offices"
	reviewDomain "github.com/superosystem/SewaKantor/backend/src/domains/review"
	transactionDomain "github.com/superosystem/SewaKantor/backend/src/domains/transactions"
	userDomain "github.com/superosystem/SewaKantor/backend/src/domains/users"
	"gorm.io/gorm"

	facilityDB "github.com/superosystem/SewaKantor/backend/src/infrastructures/databases/mysql/facilities"
	officeFacilityDB "github.com/superosystem/SewaKantor/backend/src/infrastructures/databases/mysql/office_facilities"
	officeImageDB "github.com/superosystem/SewaKantor/backend/src/infrastructures/databases/mysql/office_images"
	officeDB "github.com/superosystem/SewaKantor/backend/src/infrastructures/databases/mysql/offices"
	reviewDB "github.com/superosystem/SewaKantor/backend/src/infrastructures/databases/mysql/review"
	transactionDB "github.com/superosystem/SewaKantor/backend/src/infrastructures/databases/mysql/transactions"
	userDB "github.com/superosystem/SewaKantor/backend/src/infrastructures/databases/mysql/users"
)

func NewUserRepository(conn *gorm.DB) userDomain.Repository {
	return userDB.NewMySQLRepository(conn)
}

func NewOfficeRepository(conn *gorm.DB) officeDomain.Repository {
	return officeDB.NewMySQLRepository(conn)
}

func NewOfficeImageRepository(conn *gorm.DB) officeImageDomain.Repository {
	return officeImageDB.NewMySQLRepository(conn)
}

func NewFacilityRepository(conn *gorm.DB) facilityDomain.Repository {
	return facilityDB.NewMySQLRepository(conn)
}

func NewOfficeFacilityRepository(conn *gorm.DB) officeFacilityDomain.Repository {
	return officeFacilityDB.NewMySQLRepository(conn)
}

func NewTransactionRepository(conn *gorm.DB) transactionDomain.Repository {
	return transactionDB.NewMySQLRepository(conn)
}

func NewReviewRepository(conn *gorm.DB) reviewDomain.Repository {
	return reviewDB.NewMySQLRepository(conn)
}
