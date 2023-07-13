package repository

import (
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type HealthFacilitiesRepository interface {
	CreateHealthFacilities(data model.HealthFacility) error
	GetAllHealthFacilities() ([]model.HealthFacility, error)
	GetAllHealthFacilitiesByCity(city string) ([]model.HealthFacility, error)
	GetHealthFacilities(name string) (model.HealthFacility, error)
	GetHealthFacilitiesById(id string) (model.HealthFacility, error)
	UpdateHealthFacilities(data model.HealthFacility, id string) error
	DeleteHealthFacilities(id string) error
}

type healthFacilityRepository struct {
	db *gorm.DB
}

func NewHealthFacilityRepository(db *gorm.DB) *healthFacilityRepository {
	return &healthFacilityRepository{db: db}
}

func (r *healthFacilityRepository) CreateHealthFacilities(data model.HealthFacility) error {
	if err := r.db.Create(&data).Error; err != nil {
		return err
	}

	return nil
}

func (r *healthFacilityRepository) GetAllHealthFacilities() ([]model.HealthFacility, error) {
	var healthFacility []model.HealthFacility

	if err := r.db.Preload(clause.Associations).Preload("Vaccine.Session").Preload("Address").Model(&model.HealthFacility{}).Find(&healthFacility).Error; err != nil {
		return healthFacility, err
	}

	return healthFacility, nil
}
func (r *healthFacilityRepository) GetAllHealthFacilitiesByCity(city string) ([]model.HealthFacility, error) {
	var healthFacility []model.HealthFacility

	likeCity := "%" + city + "%"
	if err := r.db.Preload("Address").Joins("Address").Where("Address.city LIKE ?", likeCity).Find(&healthFacility).Error; err != nil {
		return healthFacility, err
	}

	return healthFacility, nil
}

func (r *healthFacilityRepository) GetHealthFacilities(name string) (model.HealthFacility, error) {
	var healthFacility model.HealthFacility

	likeName := "%" + name + "%"
	if err := r.db.Preload("Vaccine").Preload("Address").Where("name LIKE ?", likeName).First(&healthFacility).Error; err != nil {
		return healthFacility, err
	}

	return healthFacility, nil
}

func (r *healthFacilityRepository) GetHealthFacilitiesById(id string) (model.HealthFacility, error) {
	var healthFacility model.HealthFacility

	if err := r.db.Preload("Address").Model(&model.HealthFacility{}).Where("id = ?", id).First(&healthFacility).Error; err != nil {
		return healthFacility, err
	}

	return healthFacility, nil
}

func (r *healthFacilityRepository) UpdateHealthFacilities(data model.HealthFacility, id string) error {
	if err := r.db.Model(&model.HealthFacility{}).Where("id = ?", id).Updates(&data).Error; err != nil {
		return err
	}

	return nil
}

func (r *healthFacilityRepository) DeleteHealthFacilities(id string) error {
	var healthFacility model.HealthFacility

	if err := r.db.Where("id = ?", id).Delete(&healthFacility).Error; err != nil {
		return err
	}

	return nil
}
