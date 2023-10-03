package response

import (
	"github.com/superosystem/SewaKantor/backend/src/domains/office_facilities"
)

type OfficeFacility struct {
	ID           uint `json:"id" form:"id"`
	FacilitiesID uint `json:"facilities_id" form:"facilities_id"`
	OfficeID     uint `json:"office_id" form:"office_id"`
}

func FromDomain(domain officefacilities.Domain) OfficeFacility {
	return OfficeFacility{
		ID:           domain.ID,
		FacilitiesID: domain.FacilitiesID,
		OfficeID:     domain.OfficeID,
	}
}
