package officeimages

import (
	officeImageUseCase "github.com/superosystem/SewaKantor/backend/src/domains/office_images"
	"github.com/superosystem/SewaKantor/backend/src/infrastructures/databases/mysql/offices"
)

type OfficeImage struct {
	ID       uint           `json:"id" gorm:"primaryKey"`
	URL      string         `json:"url"`
	OfficeID uint           `json:"office_id"`
	Office   offices.Office `json:"office" gorm:"foreignKey:OfficeID;references:ID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}

func FromDomain(domain *officeImageUseCase.Domain) *OfficeImage {
	return &OfficeImage{
		ID:       domain.ID,
		URL:      domain.URL,
		OfficeID: domain.OfficeID,
	}
}

func (rec *OfficeImage) ToDomain() officeImageUseCase.Domain {
	return officeImageUseCase.Domain{
		ID:       rec.ID,
		URL:      rec.URL,
		OfficeID: rec.OfficeID,
	}
}
