package facilities

import (
	"github.com/superosystem/SewaKantor/backend/src/domains/facilities"
	"gorm.io/gorm"
)

type facilityRepository struct {
	conn *gorm.DB
}

func NewMySQLRepository(conn *gorm.DB) facilities.Repository {
	return &facilityRepository{
		conn: conn,
	}
}

func (fr *facilityRepository) GetAll() []facilities.Domain {
	var rec []Facility

	fr.conn.Find(&rec)

	facilityDomain := []facilities.Domain{}

	for _, facility := range rec {
		facilityDomain = append(facilityDomain, facility.ToDomain())
	}

	return facilityDomain
}

func (fr *facilityRepository) GetByID(id string) facilities.Domain {
	var facility Facility

	fr.conn.First(&facility, "id = ?", id)

	return facility.ToDomain()
}

func (fr *facilityRepository) Create(facilityDomain *facilities.Domain) facilities.Domain {
	rec := FromDomain(facilityDomain)

	result := fr.conn.Create(&rec)

	result.Last(&rec)

	return rec.ToDomain()
}

func (fr *facilityRepository) Update(id string, facilityDomain *facilities.Domain) facilities.Domain {
	var facility = fr.GetByID(id)

	updatedFacility := FromDomain(&facility)

	updatedFacility.Description = facilityDomain.Description
	updatedFacility.Slug = facilityDomain.Slug

	fr.conn.Save(&updatedFacility)

	return updatedFacility.ToDomain()
}

func (fr *facilityRepository) Delete(id string) bool {
	var facility = fr.GetByID(id)

	deletedFacility := FromDomain(&facility)

	result := fr.conn.Delete(&deletedFacility)

	if result.RowsAffected == 0 {
		return false
	}

	return true
}
