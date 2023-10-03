package response

import (
	"github.com/superosystem/SewaKantor/backend/src/domains/offices"
)

type FacilityItem struct {
	FacilitiesId   string `json:"facilities_id" form:"facilities_id"`
	FacilitiesDesc string `json:"facilities_desc" form:"facilities_desc"`
	FacilitesSlug  string `json:"facilities_slug" form:"facilities_slug"`
}

type FacilityBox struct {
	Items []FacilityItem
}

func (box *FacilityBox) AddItem(item FacilityItem) []FacilityItem {
	box.Items = append(box.Items, item)
	return box.Items
}

func FacilitiesResponse(domain offices.Domain) FacilityBox {
	items := []FacilityItem{}
	box := FacilityBox{items}
	var item FacilityItem

	for _, v := range domain.FacilitiesId {
		item = FacilityItem{FacilitiesId: v}
		box.AddItem(item)
	}

	for i := 0; i < len(box.Items); i++ {
		for j := 0; j < len(domain.FacilitiesDesc); j++ {
			if i == j {
				box.Items[i].FacilitiesDesc = domain.FacilitiesDesc[j]
			}
		}

		for k := 0; k < len(domain.FacilitesSlug); k++ {
			if i == k {
				box.Items[i].FacilitesSlug = domain.FacilitesSlug[k]
			}
		}
	}

	return box
}
