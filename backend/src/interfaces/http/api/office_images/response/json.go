package response

import (
	"github.com/superosystem/SewaKantor/backend/src/domains/office_images"
)

type OfficeImage struct {
	ID       uint   `json:"id" form:"id"`
	URL      string `json:"url" form:"url"`
	OfficeID uint   `json:"office_id" form:"office_id"`
}

func FromDomain(domain officeimages.Domain) OfficeImage {
	return OfficeImage{
		ID:       domain.ID,
		URL:      domain.URL,
		OfficeID: domain.OfficeID,
	}
}
