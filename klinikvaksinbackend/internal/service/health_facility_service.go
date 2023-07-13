package service

import (
	"github.com/google/uuid"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/dto/payload"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/dto/response"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/repository"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/util"
)

type HealthFacilitiesService interface {
	CreateHealthFacilities(payloads payload.HealthFacility) error
	GetAllHealthFacilities() ([]model.HealthFacility, error)
	GetHealthFacilities(name string) (model.HealthFacility, error)
	UpdateHealthFacilities(payloads payload.UpdateHealthFacility, id string) (response.UpdateHealthFacilities, error)
	DeleteHealthFacilities(id string) error
}

type healthFacilitiesService struct {
	HealthRepo  repository.HealthFacilitiesRepository
	AddressRepo repository.AddressRepository
	AdminRepo   repository.AdminRepository
}

func NewHealthFacilitiesService(
	healthRepo repository.HealthFacilitiesRepository,
	addressRepo repository.AddressRepository,
	adminRepo repository.AdminRepository) *healthFacilitiesService {
	return &healthFacilitiesService{
		HealthRepo:  healthRepo,
		AddressRepo: addressRepo,
		AdminRepo:   adminRepo,
	}
}

func (s *healthFacilitiesService) CreateHealthFacilities(payloads payload.HealthFacility) error {

	idHealthFacil := uuid.NewString()
	idAddr := uuid.NewString()
	idAdmin := uuid.NewString()

	healthFacil := model.HealthFacility{
		ID:       idHealthFacil,
		Email:    payloads.Email,
		PhoneNum: payloads.PhoneNum,
		Name:     payloads.Name,
		Image:    payloads.Image,
	}

	if err := s.HealthRepo.CreateHealthFacilities(healthFacil); err != nil {
		return err
	}

	address := model.Address{
		ID:                 idAddr,
		IdHealthFacilities: &idHealthFacil,
		NikUser:            nil,
		CurrentAddress:     payloads.CurrentAddress,
		District:           payloads.District,
		City:               payloads.City,
		Province:           payloads.Province,
		Longitude:          payloads.Longitude,
		Latitude:           payloads.Latitude,
	}

	if err := s.AddressRepo.CreateAddress(address); err != nil {
		return err
	}

	hashPass, err := util.HashPassword(payloads.PasswordAdmin)
	if err != nil {
		return err
	}

	adminModel := model.Admin{
		ID:                 idAdmin,
		IdHealthFacilities: idHealthFacil,
		Email:              payloads.EmailAdmin,
		Password:           hashPass,
	}

	err = s.AdminRepo.RegisterAdmin(adminModel)
	if err != nil {
		return err
	}
	return nil
}

func (s *healthFacilitiesService) GetAllHealthFacilities() ([]model.HealthFacility, error) {
	allData, err := s.HealthRepo.GetAllHealthFacilities()
	if err != nil {
		return allData, err
	}

	return allData, err
}

func (s *healthFacilitiesService) GetHealthFacilities(name string) (model.HealthFacility, error) {
	data, err := s.HealthRepo.GetHealthFacilities(name)
	if err != nil {
		return data, err
	}

	return data, nil
}

func (s *healthFacilitiesService) UpdateHealthFacilities(payloads payload.UpdateHealthFacility, id string) (response.UpdateHealthFacilities, error) {
	var dataResp response.UpdateHealthFacilities

	healthFacil := model.HealthFacility{
		Email:    payloads.Email,
		PhoneNum: payloads.PhoneNum,
		Name:     payloads.Name,
		Image:    payloads.Image,
	}

	if err := s.HealthRepo.UpdateHealthFacilities(healthFacil, id); err != nil {
		return dataResp, err
	}

	address := model.Address{
		CurrentAddress: payloads.CurrentAddress,
		District:       payloads.District,
		City:           payloads.City,
		Province:       payloads.Province,
		Longitude:      payloads.Longitude,
		Latitude:       payloads.Latitude,
	}

	if err := s.AddressRepo.UpdateAddressHealthFacilities(address, id); err != nil {
		return dataResp, err
	}

	dataResp = response.UpdateHealthFacilities{
		Email:          payloads.Email,
		PhoneNum:       payloads.PhoneNum,
		Name:           payloads.Name,
		Image:          payloads.Image,
		CurrentAddress: payloads.CurrentAddress,
		District:       payloads.District,
		City:           payloads.City,
		Province:       payloads.Province,
		Latitude:       payloads.Latitude,
		Longitude:      payloads.Longitude,
	}
	return dataResp, nil
}

func (s *healthFacilitiesService) DeleteHealthFacilities(id string) error {
	if err := s.AddressRepo.DeleteAddressHealthFacilities(id); err != nil {
		return err
	}

	if err := s.AdminRepo.DeleteAdminByHealth(id); err != nil {
		return err
	}

	if err := s.HealthRepo.DeleteHealthFacilities(id); err != nil {
		return err
	}

	return nil
}
