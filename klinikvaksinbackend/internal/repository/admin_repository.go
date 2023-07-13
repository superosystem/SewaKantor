package repository

import (
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
	"gorm.io/gorm"
)

type AdminRepository interface {
	RegisterAdmin(data model.Admin) error
	LoginAdmin(data model.Admin) (model.Admin, error)
	GetAllAdmin() ([]model.Admin, error)
	GetAdmins(id string) (model.Admin, error)
	UpdateAdmin(data model.Admin, id string) error
	DeleteAdmin(id string) error
	DeleteAdminByHealth(id string) error
}

type adminRepository struct {
	db *gorm.DB
}

func NewAdminsRepository(db *gorm.DB) *adminRepository {
	return &adminRepository{db: db}
}

func (r *adminRepository) RegisterAdmin(data model.Admin) error {
	if err := r.db.Create(&data).Error; err != nil {
		return err
	}

	return nil
}

func (r *adminRepository) LoginAdmin(data model.Admin) (model.Admin, error) {
	var admins model.Admin

	if err := r.db.Where("email = ?", data.Email).First(&admins).Error; err != nil {
		return admins, err
	}

	return admins, nil
}

func (r *adminRepository) GetAllAdmin() ([]model.Admin, error) {
	var admins []model.Admin
	if err := r.db.Model(&model.Admin{}).Find(&admins).Error; err != nil {
		return admins, err
	}

	return admins, nil
}

func (r *adminRepository) GetAdmins(id string) (model.Admin, error) {
	var admins model.Admin

	if err := r.db.Where("id = ?", id).First(&admins).Error; err != nil {
		return admins, err
	}

	return admins, nil
}

func (r *adminRepository) UpdateAdmin(data model.Admin, id string) error {
	if err := r.db.Model(&model.Admin{}).Where("id = ?", id).Updates(&data).Error; err != nil {
		return err
	}

	return nil
}

func (r *adminRepository) DeleteAdmin(id string) error {
	var admins model.Admin
	if err := r.db.Where("id = ?", id).Delete(&admins).Error; err != nil {
		return err
	}

	return nil
}

func (r *adminRepository) DeleteAdminByHealth(id string) error {
	var admins model.Admin
	if err := r.db.Where("id_health_facilities = ?", id).Delete(&admins).Error; err != nil {
		return err
	}

	return nil
}
