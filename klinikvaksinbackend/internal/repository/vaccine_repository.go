package repository

import (
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
	"gorm.io/gorm"
)

type VaccinesRepository interface {
	CreateVaccine(data model.Vaccine) error
	GetAllVaccines() ([]model.Vaccine, error)
	GetVaccinesById(id string) (model.Vaccine, error)
	GetVaccinesByIdAdmin(idHealthFacility string) ([]model.Vaccine, error)
	GetVaccineByName() ([]model.Vaccine, error)
	UpdateVaccine(data model.Vaccine, id string) error
	DeleteVaccine(id string) error
	CheckNameDosesExist(idHealthFacility, name string, dose int) (model.Vaccine, error)
}

type vaccinesRepository struct {
	db *gorm.DB
}

func NewVaccinesRepository(db *gorm.DB) *vaccinesRepository {
	return &vaccinesRepository{db: db}
}

func (v *vaccinesRepository) CreateVaccine(data model.Vaccine) error {
	if err := v.db.Create(&data).Error; err != nil {
		return err
	}

	return nil
}

func (v *vaccinesRepository) GetAllVaccines() ([]model.Vaccine, error) {
	var vaccines []model.Vaccine

	if err := v.db.Model(&model.Vaccine{}).Order("name").Find(&vaccines).Error; err != nil {
		return vaccines, err
	}

	return vaccines, nil
}

func (v *vaccinesRepository) GetVaccinesById(id string) (model.Vaccine, error) {
	var vaccines model.Vaccine
	if err := v.db.Model(&model.Vaccine{}).Where("id = ?", id).Find(&vaccines).Error; err != nil {
		return vaccines, err
	}

	return vaccines, nil
}

func (v *vaccinesRepository) GetVaccinesByIdAdmin(idhealthfacil string) ([]model.Vaccine, error) {
	var vaccines []model.Vaccine

	if err := v.db.Model(&model.Vaccine{}).Where("id_health_facilities = ?", idhealthfacil).Find(&vaccines).Error; err != nil {
		return vaccines, err
	}

	return vaccines, nil
}

func (v *vaccinesRepository) GetVaccineByName() ([]model.Vaccine, error) {
	var vaccines []model.Vaccine

	if err := v.db.Raw("SELECT name, SUM(stock) AS stock FROM vaccines GROUP BY name ORDER BY created_at DESC").Scan(&vaccines).Error; err != nil {
		return vaccines, err
	}

	return vaccines, nil
}

func (v *vaccinesRepository) UpdateVaccine(data model.Vaccine, id string) error {
	if err := v.db.Model(&model.Vaccine{}).Where("id = ?", id).Updates(&data).Error; err != nil {
		return err
	}

	return nil
}

func (v *vaccinesRepository) DeleteVaccine(id string) error {
	var vaccines model.Vaccine

	if err := v.db.Where("id = ?", id).Delete(&vaccines).Error; err != nil {
		return err
	}

	return nil
}

func (v *vaccinesRepository) CheckNameDosesExist(idhealthfacil, name string, dose int) (model.Vaccine, error) {
	var vaccines model.Vaccine

	if err := v.db.Model(&model.Vaccine{}).Where("id_health_facilities = ? AND name = ? AND dose = ?", idhealthfacil, name, dose).First(&vaccines).Error; err != nil {
		return vaccines, err
	}

	return vaccines, nil
}
