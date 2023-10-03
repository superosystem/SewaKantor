package facilities

type Domain struct {
	ID          uint
	Description string
	Slug        string
}

type Usecase interface {
	GetAll() []Domain
	GetByID(id string) Domain
	Create(facilityDomain *Domain) Domain
	Update(id string, facilityDomain *Domain) Domain
	Delete(id string) bool
}

type Repository interface {
	GetAll() []Domain
	GetByID(id string) Domain
	Create(facilityDomain *Domain) Domain
	Update(id string, facilityDomain *Domain) Domain
	Delete(id string) bool
}
