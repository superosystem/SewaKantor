package facilities

import (
	facilityUsecase "github.com/superosystem/SewaKantor/backend/src/domains/facilities"
)

type Facility struct {
	ID          uint   `gorm:"primaryKey" json:"id" form:"id"`
	Description string `json:"description" form:"description"`
	Slug        string `json:"slug" form:"slug"`
}

func FromDomain(domain *facilityUsecase.Domain) *Facility {
	return &Facility{
		ID:          domain.ID,
		Description: domain.Description,
		Slug:        domain.Slug,
	}
}

func (rec *Facility) ToDomain() facilityUsecase.Domain {
	return facilityUsecase.Domain{
		ID:          rec.ID,
		Description: rec.Description,
		Slug:        rec.Slug,
	}
}
