package review

type reviewUsecase struct {
	reviewRepository Repository
}

func NewReviewUsecase(rv Repository) Usecase {
	return &reviewUsecase{
		reviewRepository: rv,
	}
}

func (ru *reviewUsecase) GetAll() []Domain {
	return ru.reviewRepository.GetAll()
}

func (ru *reviewUsecase) Create(reviewDomain *Domain) Domain {
	return ru.reviewRepository.Create(reviewDomain)
}

func (ru *reviewUsecase) GetByID(id string) Domain {
	return ru.reviewRepository.GetByID(id)
}

func (ru *reviewUsecase) Update(id string, reviewDomain *Domain) Domain {
	return ru.reviewRepository.Update(id, reviewDomain)
}

func (ru *reviewUsecase) Delete(id string) bool {
	return ru.reviewRepository.Delete(id)
}

func (ru *reviewUsecase) GetByUserID(userId string) []Domain {
	return ru.reviewRepository.GetByUserID(userId)
}

func (ru *reviewUsecase) AdminGetByUserID(userId string) []Domain {
	return ru.reviewRepository.GetByUserID(userId)
}

func (ru *reviewUsecase) GetByOfficeID(officeId string) []Domain {
	return ru.reviewRepository.GetByOfficeID(officeId)
}
