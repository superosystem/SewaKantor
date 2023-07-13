package service

import (
	"github.com/google/uuid"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/dto/payload"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/dto/response"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/repository"
)

type HistoriesRepository interface {
	CreateHistory(payloads payload.HistoryPayload) error
	GetAllHistory() ([]response.HistoryResponse, error)
	GetHistoryById(id string) (response.HistoryResponse, error)
	UpdateHistory(id string, payloads payload.UpdateAccHistory) (response.HistoryResponse, error)
	GetTotalUserVaccinated() (response.VaccinatedUser, error)
}

type historiesService struct {
	HistoriesRepo repository.HistoriesRepository
}

func NewHistoriesService(historiesRepo repository.HistoriesRepository) *historiesService {
	return &historiesService{
		HistoriesRepo: historiesRepo,
	}
}

func (s *historiesService) CreateHistory(payloads payload.HistoryPayload) error {
	var historyModel model.VaccineHistory

	id := uuid.NewString()

	historyModel = model.VaccineHistory{
		ID:         id,
		IdBooking:  payloads.IdBooking,
		NikUser:    payloads.NikUser,
		IdSameBook: payloads.IdSameBook,
		Status:     &payloads.Status,
	}

	err := s.HistoriesRepo.CreateHistory(historyModel)

	if err != nil {
		return err
	}

	return nil
}

func (s *historiesService) GetAllHistory() ([]response.HistoryResponse, error) {
	var historyResponse []response.HistoryResponse

	getHistory, err := s.HistoriesRepo.GetAllHistory()

	if err != nil {
		return historyResponse, err
	}

	historyResponse = make([]response.HistoryResponse, len(getHistory))

	for i, v := range getHistory {
		historyResponse[i] = response.HistoryResponse{
			ID:         v.ID,
			IdBooking:  v.IdBooking,
			NikUser:    v.NikUser,
			IdSameBook: v.IdSameBook,
			Status:     v.Status,
			CreatedAt:  v.CreatedAt,
			UpdatedAt:  v.UpdatedAt,
			User:       *v.User,
		}
	}

	return historyResponse, nil
}

func (s *historiesService) GetHistoryById(id string) (response.HistoryResponse, error) {
	var responseHistory response.HistoryResponse

	getData, err := s.HistoriesRepo.GetHistoryById(id)
	if err != nil {
		return responseHistory, err
	}

	responseHistory = response.HistoryResponse{
		ID:         getData.ID,
		IdBooking:  getData.IdBooking,
		NikUser:    getData.NikUser,
		IdSameBook: getData.IdSameBook,
		Status:     getData.Status,
		CreatedAt:  getData.CreatedAt,
		UpdatedAt:  getData.UpdatedAt,
		User:       *getData.User,
	}

	return responseHistory, nil
}

func (s *historiesService) UpdateHistory(id string, payloads payload.UpdateAccHistory) (response.HistoryResponse, error) {
	var responseHistory response.HistoryResponse

	historyData := model.VaccineHistory{
		ID:      payloads.ID,
		NikUser: payloads.NikUser,
		Status:  &payloads.Status,
	}

	if _, err := s.HistoriesRepo.UpdateHistory(historyData, id); err != nil {
		return responseHistory, err
	}
	return responseHistory, nil
}

func (s *historiesService) GetTotalUserVaccinated() (response.VaccinatedUser, error) {
	var responseHistory response.VaccinatedUser

	data, err := s.HistoriesRepo.GetTotalUserVaccinated()
	if err != nil {
		return responseHistory, err
	}

	responseHistory = data

	return responseHistory, nil
}
