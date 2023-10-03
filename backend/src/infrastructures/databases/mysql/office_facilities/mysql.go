package officefacilities

import (
	"github.com/superosystem/SewaKantor/backend/src/domains/office_facilities"

	"gorm.io/gorm"
)

type officeFacilityRepository struct {
	conn *gorm.DB
}

func NewMySQLRepository(conn *gorm.DB) officefacilities.Repository {
	return &officeFacilityRepository{
		conn: conn,
	}
}

func (fac *officeFacilityRepository) GetAll() []officefacilities.Domain {
	var rec []OfficeFacility

	fac.conn.Find(&rec)

	officeFacilityDomain := []officefacilities.Domain{}

	for _, f := range rec {
		officeFacilityDomain = append(officeFacilityDomain, f.ToDomain())
	}

	return officeFacilityDomain
}

func (fac *officeFacilityRepository) GetByOfficeID(officeID string) []officefacilities.Domain {
	var rec []OfficeFacility

	fac.conn.Preload("Office").Where("office_id", officeID).Find(&rec)

	officeFacilityDomain := []officefacilities.Domain{}

	for _, f := range rec {
		officeFacilityDomain = append(officeFacilityDomain, f.ToDomain())
	}

	return officeFacilityDomain
}

func (fac *officeFacilityRepository) Create(officeFacilityDomain *officefacilities.Domain) officefacilities.Domain {
	rec := FromDomain(officeFacilityDomain)

	result := fac.conn.Preload("offices").Create(&rec)

	result.Last(&rec)

	return rec.ToDomain()
}
