package offices

import (
	"sort"
	"strconv"
	"strings"
)

type OfficeUsecase struct {
	officeRepository Repository
}

type byRate []Domain

func NewOfficeUsecase(or Repository) Usecase {
	return &OfficeUsecase{
		officeRepository: or,
	}
}

func (a byRate) Len() int           { return len(a) }
func (a byRate) Less(i, j int) bool { return a[i].Rate < a[j].Rate }
func (a byRate) Swap(i, j int)      { a[i], a[j] = a[j], a[i] }

func (ou *OfficeUsecase) GetAll() []Domain {
	return ou.officeRepository.GetAll()
}

func (ou *OfficeUsecase) GetByID(id string) Domain {
	return ou.officeRepository.GetByID(id)
}

func (ou *OfficeUsecase) Create(officeDomain *Domain) Domain {
	return ou.officeRepository.Create(officeDomain)
}

func (ou *OfficeUsecase) Update(id string, officeDomain *Domain) Domain {
	return ou.officeRepository.Update(id, officeDomain)
}

func (ou *OfficeUsecase) Delete(id string) bool {
	return ou.officeRepository.Delete(id)
}

func (ou *OfficeUsecase) SearchByCity(city string) []Domain {
	rec := ou.officeRepository.GetAll()
	var offices []Domain

	city = strings.TrimSpace(city)
	city = strings.ToLower(city)

	for _, office := range rec {
		if office.City == city {
			offices = append(offices, office)
		}
	}

	return offices
}

func (ou *OfficeUsecase) SearchByRate(rate string) []Domain {
	rec := ou.officeRepository.GetAll()
	var offices []Domain
	intRate, _ := strconv.Atoi(rate)

	for _, office := range rec {
		switch intRate {
		case 5:
			if office.Rate == 5 {
				offices = append(offices, office)
			}
		case 0:
			if office.Rate == 0 {
				offices = append(offices, office)
			}
		default:
			if office.Rate >= float64(intRate) && office.Rate < (float64(intRate)+1) {
				offices = append(offices, office)
			}
		}
	}

	return offices
}

func (ou *OfficeUsecase) SearchByTitle(title string) Domain {
	rec := ou.officeRepository.GetAll()
	var offices Domain

	title = strings.TrimSpace(title)
	title = strings.ToLower(title)

	for _, office := range rec {
		office.Title = strings.ToLower(office.Title)

		if office.Title == title {
			offices = office
			break
		}
	}

	return offices
}

func (ou *OfficeUsecase) GetCoworkingSpace() []Domain {
	rec := ou.officeRepository.GetAll()

	var offices []Domain

	for _, office := range rec {
		if office.OfficeType == "coworking space" {
			offices = append(offices, office)
		}
	}

	return offices
}

func (ou *OfficeUsecase) GetOffices() []Domain {
	rec := ou.officeRepository.GetAll()

	var offices []Domain

	for _, office := range rec {
		if office.OfficeType == "office" {
			offices = append(offices, office)
		}
	}

	return offices
}

func (ou *OfficeUsecase) GetMeetingRooms() []Domain {
	rec := ou.officeRepository.GetAll()

	var offices []Domain

	for _, office := range rec {
		if office.OfficeType == "meeting room" {
			offices = append(offices, office)
		}
	}

	return offices
}

func (ou *OfficeUsecase) GetRecommendation() []Domain {
	rec := ou.officeRepository.GetAll()

	sort.Sort(sort.Reverse(byRate(rec)))

	return rec
}

func (ou *OfficeUsecase) GetNearest(lat string, long string) []Domain {
	return ou.officeRepository.GetNearest(lat, long)
}
