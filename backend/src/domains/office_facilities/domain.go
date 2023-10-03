package officefacilities

type Domain struct {
	ID           uint
	FacilitiesID uint
	OfficeID     uint
}

type Usecase interface {
	GetAll() []Domain
	GetByOfficeID(id string) []Domain
	Create(officeFacilityDomain *Domain) Domain
}

type Repository interface {
	GetAll() []Domain
	GetByOfficeID(id string) []Domain
	Create(officeFacilityDomain *Domain) Domain
}
