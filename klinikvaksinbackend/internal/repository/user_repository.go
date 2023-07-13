package repository

import (
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/dto/response"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
	"gorm.io/gorm"
)

type UserRepository interface {
	RegisterUser(data model.User) error
	CheckExistNik(nik string) (model.User, error)
	ReactivatedUser(nik string) error
	ReactivatedUpdateUser(data model.User, nik string) error
	ReactivatedAddress(nik string) error
	LoginUser(data model.User) (model.User, error)
	GetDataByIdBooking(id string) (model.User, error)
	GetUserDataByNik(nik string) (model.User, error)
	GetUserDataByNikNoAddress(nik string) (model.User, error)
	GetUserHistoryByNik(nik string) (model.User, error)
	GetAllUser() ([]model.User, error)
	UpdateAccUserProfile(data model.User) error
	UpdateUserProfile(data model.User, nik string) error
	GetAgeUser(data model.User) (response.AgeUser, error)
	DeleteUser(nik string) error
	NearbyHealthFacilities(city string) ([]model.Address, error)
}

type userRepository struct {
	db *gorm.DB
}

func NewUserRepository(db *gorm.DB) *userRepository {
	return &userRepository{db: db}
}

func (r *userRepository) RegisterUser(data model.User) error {
	if err := r.db.Create(&data).Error; err != nil {
		return err
	}

	return nil
}

func (r *userRepository) CheckExistNik(nik string) (model.User, error) {
	var user model.User

	if err := r.db.Unscoped().Where("nik = ?", nik).First(&user).Error; err != nil {
		return user, err
	}

	return user, nil
}

func (r *userRepository) ReactivatedUser(nik string) error {
	var user model.User

	if err := r.db.Unscoped().Model(&user).Where("nik = ?", nik).Update("deleted_at", nil).Error; err != nil {
		return err
	}

	return nil
}

func (r *userRepository) ReactivatedUpdateUser(data model.User, nik string) error {
	var user model.User

	if err := r.db.Unscoped().Model(&user).Where("nik = ?", nik).Updates(&data).Error; err != nil {
		return err
	}

	return nil
}

func (r *userRepository) ReactivatedAddress(nik string) error {
	var address model.Address

	if err := r.db.Unscoped().Model(&address).Where("nik_user = ?", nik).Update("deleted_at", nil).Error; err != nil {
		return err
	}

	return nil
}

func (r *userRepository) LoginUser(data model.User) (model.User, error) {
	var user model.User

	if err := r.db.Where("email = ?", data.Email).First(&user).Error; err != nil {
		return user, err
	}

	return user, nil
}

func (r *userRepository) GetDataByIdBooking(id string) (model.User, error) {
	var user model.User

	if err := r.db.Preload("History").Joins("History").Where("History.id_booking = ?", id).First(&user).Error; err != nil {
		return user, err
	}
	return user, nil
}

func (r *userRepository) GetUserDataByNik(nik string) (model.User, error) {
	var user model.User

	if err := r.db.Preload("Address").Where("nik = ?", nik).First(&user).Error; err != nil {
		return user, err
	}

	return user, nil
}

func (r *userRepository) GetUserHistoryByNik(nik string) (model.User, error) {
	var user model.User

	if err := r.db.Preload("History.Booking.Session.Vaccine").Preload("Address").Where("nik = ?", nik).First(&user).Error; err != nil {
		return user, err
	}

	return user, nil
}

func (r *userRepository) GetUserDataByNikNoAddress(nik string) (model.User, error) {
	var user model.User

	if err := r.db.Preload("History").Where("nik = ?", nik).First(&user).Error; err != nil {
		return user, err
	}

	return user, nil
}

func (r *userRepository) GetAllUser() ([]model.User, error) {
	var user []model.User

	if err := r.db.Preload("Address").Preload("History").Model(&model.User{}).Find(&user).Error; err != nil {
		return user, err
	}

	return user, nil
}

func (r *userRepository) UpdateUserProfile(data model.User, nik string) error {
	var user model.User

	if err := r.db.Model(&user).Where("nik = ?", nik).Updates(&data).Error; err != nil {
		return err
	}

	return nil
}

func (r *userRepository) UpdateAccUserProfile(data model.User) error {
	var user model.User

	if err := r.db.Model(&user).Where("nik = ?", data.NIK).Updates(&data).Error; err != nil {
		return err
	}

	return nil
}

func (r *userRepository) GetAgeUser(data model.User) (response.AgeUser, error) {
	var age response.AgeUser

	if err := r.db.Raw("SELECT birth_date, DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(), ?)), '%Y') + 0 AS age FROM users", data.BirthDate).Scan(&age).Error; err != nil {
		return age, err
	}
	return age, nil
}

func (r *userRepository) DeleteUser(nik string) error {
	var user model.User

	if err := r.db.Where("nik = ?", nik).Find(&user).Unscoped().Delete(&user).Error; err != nil {
		return err
	}

	return nil
}

func (r *userRepository) NearbyHealthFacilities(city string) ([]model.Address, error) {
	var address []model.Address

	if err := r.db.Where("city = ? AND nik_user = ?", city, nil).Find(&address).Error; err != nil {
		return address, err
	}

	return address, nil
}
