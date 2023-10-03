package facilities

import "github.com/gosimple/slug"

type FacilityUsecase struct {
	facilityRepository Repository
}

func NewFacilityUsecase(fr Repository) Usecase {
	return &FacilityUsecase{
		facilityRepository: fr,
	}
}

func (fu *FacilityUsecase) GetAll() []Domain {
	return fu.facilityRepository.GetAll()
}

func (fu *FacilityUsecase) GetByID(id string) Domain {
	return fu.facilityRepository.GetByID(id)
}

func (fu *FacilityUsecase) Create(facilityDomain *Domain) Domain {
	slug := slug.Make(facilityDomain.Description)
	facilityDomain.Slug = slug

	return fu.facilityRepository.Create(facilityDomain)
}

func (fu *FacilityUsecase) Update(id string, facilityDomain *Domain) Domain {
	slug := slug.Make(facilityDomain.Description)
	facilityDomain.Slug = slug

	return fu.facilityRepository.Update(id, facilityDomain)
}

func (fu *FacilityUsecase) Delete(id string) bool {
	return fu.facilityRepository.Delete(id)
}
