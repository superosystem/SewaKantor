package officeimages

type OfficeImageUsecase struct {
	officeImageRepository Repository
}

func NewOfficeImageUsecase(r Repository) Usecase {
	return &OfficeImageUsecase{
		officeImageRepository: r,
	}
}

func (uc *OfficeImageUsecase) GetByOfficeID(id string) []Domain {
	return uc.officeImageRepository.GetByOfficeID(id)
}

func (uc *OfficeImageUsecase) Create(officeImgDomain *Domain) Domain {
	return uc.officeImageRepository.Create(officeImgDomain)
}
