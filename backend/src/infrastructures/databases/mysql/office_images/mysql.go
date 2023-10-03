package officeimages

import (
	"github.com/superosystem/SewaKantor/backend/src/domains/office_images"

	"gorm.io/gorm"
)

type officeImageRepository struct {
	conn *gorm.DB
}

func NewMySQLRepository(conn *gorm.DB) officeimages.Repository {
	return &officeImageRepository{
		conn: conn,
	}
}

func (r *officeImageRepository) GetByOfficeID(officeID string) []officeimages.Domain {
	var rec []OfficeImage

	r.conn.Preload("Office").Where("office_id", officeID).Find(&rec)

	officeImageDomain := []officeimages.Domain{}

	for _, v := range rec {
		officeImageDomain = append(officeImageDomain, v.ToDomain())
	}

	return officeImageDomain
}

func (r *officeImageRepository) Create(officeImageDomain *officeimages.Domain) officeimages.Domain {
	rec := FromDomain(officeImageDomain)

	result := r.conn.Preload("offices").Create(&rec)

	result.Last(&rec)

	return rec.ToDomain()
}
