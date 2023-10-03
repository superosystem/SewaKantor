package officefacilities

type officeFacilityUsecase struct {
	officeFacilityRepository Repository
}

func NewOfficeFacilityUsecase(ofr Repository) Usecase {
	return &officeFacilityUsecase{
		officeFacilityRepository: ofr,
	}
}

func (ofu *officeFacilityUsecase) GetAll() []Domain {
	return ofu.officeFacilityRepository.GetAll()
}

func (ofu *officeFacilityUsecase) GetByOfficeID(id string) []Domain {
	return ofu.officeFacilityRepository.GetByOfficeID(id)
}

func (ofu *officeFacilityUsecase) Create(officeFacilityDomain *Domain) Domain {
	return ofu.officeFacilityRepository.Create(officeFacilityDomain)
}
