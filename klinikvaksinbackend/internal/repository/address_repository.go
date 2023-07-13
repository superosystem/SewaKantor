package repository

import (
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
	"gorm.io/gorm"
)

type AddressRepository interface {
	CreateAddress(data model.Address) error
	UpdateAddressUser(data model.Address, nik string) error
	UpdateAddressHealthFacilities(data model.Address, id string) error
	GetAddressUser(nik string) (model.Address, error)
	GetAddressHealthFacilities(id string) (model.Address, error)
	DeleteAddressUser(nik string) error
	DeleteAddressHealthFacilities(id string) error
}

type addressRepository struct {
	db *gorm.DB
}

func NewAddressRepository(db *gorm.DB) *addressRepository {
	return &addressRepository{db: db}
}

func (r *addressRepository) CreateAddress(data model.Address) error {
	if err := r.db.Save(&data).Error; err != nil {
		return err
	}

	return nil
}

func (r *addressRepository) UpdateAddressUser(data model.Address, nik string) error {
	var address model.Address

	if err := r.db.Model(&address).Where("nik_user = ?", nik).Updates(&data).Error; err != nil {
		return err
	}

	return nil
}

func (r *addressRepository) UpdateAddressHealthFacilities(data model.Address, id string) error {
	var address model.Address

	if err := r.db.Model(&address).Where("id_health_facilities = ?", id).Updates(&data).Error; err != nil {
		return err
	}

	return nil
}

func (r *addressRepository) GetAddressUser(nik string) (model.Address, error) {
	var address model.Address

	if err := r.db.Where("nik_user = ?", nik).First(&address).Error; err != nil {
		return address, err
	}

	return address, nil
}

func (r *addressRepository) GetAddressHealthFacilities(id string) (model.Address, error) {
	var address model.Address

	if err := r.db.Where("id_health_facilities = ?", id).First(&address).Error; err != nil {
		return address, err
	}

	return address, nil
}

func (r *addressRepository) DeleteAddressUser(nik string) error {
	var address model.Address

	if err := r.db.Where("nik_user = ?", nik).Find(&address).Unscoped().Delete(&address).Error; err != nil {
		return err
	}

	return nil
}

func (r *addressRepository) DeleteAddressHealthFacilities(id string) error {
	var address model.Address

	if err := r.db.Where("id_health_facilities = ?", id).Find(&address).Delete(&address).Error; err != nil {
		return err
	}

	return nil
}
