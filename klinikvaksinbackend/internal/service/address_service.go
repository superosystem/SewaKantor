package service

import (
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/dto/payload"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/repository"
)

type AddressService interface {
	GetAddressUser(nik string) (model.Address, error)
	UpdateUserAddress(payloads payload.UpdateAddress, nik string) (payload.UpdateAddress, error)
}

type addressService struct {
	AddressRepo repository.AddressRepository
}

func NewAddressesService(addressRepo repository.AddressRepository) *addressService {
	return &addressService{
		AddressRepo: addressRepo,
	}
}

func (s *addressService) GetAddressUser(nik string) (model.Address, error) {
	var address model.Address

	dataAddress, err := s.AddressRepo.GetAddressUser(nik)
	if err != nil {
		return address, err
	}

	return dataAddress, nil
}

func (s *addressService) UpdateUserAddress(payloads payload.UpdateAddress, nik string) (payload.UpdateAddress, error) {
	var addressResp payload.UpdateAddress

	newAddress := model.Address{
		CurrentAddress: payloads.CurrentAddress,
		District:       payloads.District,
		City:           payloads.City,
		Province:       payloads.Province,
		Longitude:      payloads.Longitude,
		Latitude:       payloads.Latitude,
	}

	if err := s.AddressRepo.UpdateAddressUser(newAddress, nik); err != nil {
		return addressResp, err
	}

	addressResp = payloads
	return addressResp, nil
}
