package service

import (
	"fmt"

	"github.com/google/uuid"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/dto/payload"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/dto/response"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/repository"
)

type VaccinesService interface {
	CreateVaccine(idhealth string, payloads payload.VaccinePayload) (model.Vaccine, error)
	GetAllVaccines() ([]response.VaccinesResponse, error)
	GetVaccineByAdmin(idhealthfacilities string) ([]model.Vaccine, error)
	GetVaccineDashboard() ([]response.DashboardVaccine, error)
	GetVaccinesCount() ([]response.VaccinesStockResponse, error)
	UpdateVaccine(id string, payloads payload.VaccineUpdatePayload) (response.VaccinesResponse, error)
	DeleteVacccine(id string) error
}

type vaccinesService struct {
	VaccinesRepo repository.VaccinesRepository
}

func NewVaccinesService(vaccinesRepo repository.VaccinesRepository) *vaccinesService {
	return &vaccinesService{
		VaccinesRepo: vaccinesRepo,
	}
}

func (s *vaccinesService) CreateVaccine(idhealth string, payloads payload.VaccinePayload) (model.Vaccine, error) {
	var vaccineModel model.Vaccine

	id := uuid.NewString()

	vaccineData, err := s.VaccinesRepo.CheckNameDosesExist(idhealth, payloads.Name, payloads.Dose)
	if err == nil {
		fmt.Println(vaccineData.ID)
		addStock := payloads.Stock + vaccineData.Stock
		payloadUpdate := payload.VaccineUpdatePayload{
			Stock: addStock,
		}

		dataUpdate, err := s.UpdateVaccine(vaccineData.ID, payloadUpdate)
		if err != nil {
			return vaccineModel, err
		}

		vaccineModel = model.Vaccine{
			ID:                 dataUpdate.ID,
			IdHealthFacilities: idhealth,
			Name:               payloads.Name,
			Stock:              addStock,
			Dose:               payloads.Dose,
			CreatedAt:          vaccineData.CreatedAt,
			UpdatedAt:          vaccineData.UpdatedAt,
		}

		return vaccineModel, nil
	}

	vaccineModel = model.Vaccine{
		ID:                 id,
		IdHealthFacilities: idhealth,
		Name:               payloads.Name,
		Dose:               payloads.Dose,
		Stock:              payloads.Stock,
	}

	err = s.VaccinesRepo.CreateVaccine(vaccineModel)
	if err != nil {
		return vaccineModel, err
	}

	return vaccineModel, nil
}

func (s *vaccinesService) GetVaccinesCount() ([]response.VaccinesStockResponse, error) {
	var vaccinesResponse []response.VaccinesStockResponse

	getName, err := s.VaccinesRepo.GetVaccineByName()
	if err != nil {
		return vaccinesResponse, err
	}

	vaccinesResponse = make([]response.VaccinesStockResponse, len(getName))

	for i, val := range getName {
		vaccinesResponse[i] = response.VaccinesStockResponse{
			Name:  val.Name,
			Stock: val.Stock,
		}
	}

	return vaccinesResponse, nil
}

func (s *vaccinesService) GetAllVaccines() ([]response.VaccinesResponse, error) {
	var vaccinesResponse []response.VaccinesResponse

	getVaccine, err := s.VaccinesRepo.GetAllVaccines()

	if err != nil {
		return vaccinesResponse, err
	}

	vaccinesResponse = make([]response.VaccinesResponse, len(getVaccine))

	for i, v := range getVaccine {
		vaccinesResponse[i] = response.VaccinesResponse{
			ID:    v.ID,
			Name:  v.Name,
			Dose:  v.Dose,
			Stock: v.Stock,
		}
	}

	return vaccinesResponse, nil
}

func (s *vaccinesService) GetVaccineByAdmin(idhealthfacilities string) ([]model.Vaccine, error) {
	var vaccines []model.Vaccine

	vaccines, err := s.VaccinesRepo.GetVaccinesByIdAdmin(idhealthfacilities)
	if err != nil {
		return vaccines, err
	}

	return vaccines, nil
}

func (s *vaccinesService) UpdateVaccine(id string, payloads payload.VaccineUpdatePayload) (response.VaccinesResponse, error) {
	var dataResp response.VaccinesResponse

	vaccineData := model.Vaccine{
		Name:  payloads.Name,
		Dose:  payloads.Dose,
		Stock: payloads.Stock,
	}

	if err := s.VaccinesRepo.UpdateVaccine(vaccineData, id); err != nil {
		return dataResp, err
	}

	dataResp = response.VaccinesResponse{
		ID:    id,
		Name:  payloads.Name,
		Dose:  payloads.Dose,
		Stock: payloads.Stock,
	}

	return dataResp, nil
}

func (s *vaccinesService) DeleteVacccine(id string) error {
	if err := s.VaccinesRepo.DeleteVaccine(id); err != nil {
		return err
	}

	return nil
}

func (s *vaccinesService) GetVaccineDashboard() ([]response.DashboardVaccine, error) {
	var vaccinesResponse []response.DashboardVaccine

	getVaccine, err := s.VaccinesRepo.GetAllVaccines()

	if err != nil {
		return vaccinesResponse, err
	}

	vaccinesResponse = make([]response.DashboardVaccine, len(getVaccine))

	for i, v := range getVaccine {
		vaccinesResponse[i] = response.DashboardVaccine{
			Name: v.Name,
			Dose: v.Dose,
		}
	}

	return vaccinesResponse, nil
}
