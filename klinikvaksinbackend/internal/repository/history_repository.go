package repository

import (
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/dto/response"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type HistoriesRepository interface {
	CreateHistory(data model.VaccineHistory) error
	GetAllHistory() ([]model.VaccineHistory, error)
	GetHistoryById(id string) (model.VaccineHistory, error)
	GetHistoryByIdNoUserHistory(id string) (model.VaccineHistory, error)
	GetHistoriesById(id string) ([]model.VaccineHistory, error)
	GetHistoryByIdBooking(id string) ([]model.VaccineHistory, error)
	GetOneHistoryByIdBooking(id string) (response.SessionCustomHistory, error)
	GetHistoriesByIdBooking(id string) ([]model.VaccineHistory, error)
	GetHistoryByIdSameBook(id string) ([]model.VaccineHistory, error)
	GetHistoryByNIK(id, nik string) (model.VaccineHistory, error)
	GetHistoriesByNIK(nik string) ([]model.VaccineHistory, error)
	UpdateHistoryByNik(data model.VaccineHistory, nik, id string) (model.VaccineHistory, error)
	UpdateHistory(data model.VaccineHistory, id string) (model.VaccineHistory, error)
	CheckVaccineCount(nik string) ([]model.VaccineHistory, error)
	GetTotalUserVaccinated() (response.VaccinatedUser, error)
}

type historyRepository struct {
	db *gorm.DB
}

func NewHistoryRepository(db *gorm.DB) *historyRepository {
	return &historyRepository{
		db: db,
	}
}

func (r *historyRepository) CreateHistory(data model.VaccineHistory) error {
	if err := r.db.Create(&data).Error; err != nil {
		return err
	}

	return nil
}
func (r *historyRepository) GetAllHistory() ([]model.VaccineHistory, error) {
	var history []model.VaccineHistory

	if err := r.db.Model(&model.VaccineHistory{}).Find(&history).Error; err != nil {
		return history, err
	}

	return history, nil
}

func (r *historyRepository) GetHistoryById(id string) (model.VaccineHistory, error) {
	var history model.VaccineHistory

	if err := r.db.Preload(clause.Associations).Preload("Booking."+clause.Associations).Preload("User."+clause.Associations).Where("id = ?", id).First(&history).Error; err != nil {
		return history, err
	}

	return history, nil
}

func (r *historyRepository) GetHistoryByIdNoUserHistory(id string) (model.VaccineHistory, error) {
	var history model.VaccineHistory

	if err := r.db.Preload(clause.Associations).Preload("Booking."+clause.Associations).Preload("User.Address").Where("id = ?", id).First(&history).Error; err != nil {
		return history, err
	}

	return history, nil
}

func (r *historyRepository) GetHistoriesById(id string) ([]model.VaccineHistory, error) {
	var history []model.VaccineHistory

	if err := r.db.Preload(clause.Associations).Preload("Booking."+clause.Associations).Where("id = ?", id).Find(&history).Error; err != nil {
		return history, err
	}

	return history, nil
}

func (r *historyRepository) GetOneHistoryByIdBooking(id string) (response.SessionCustomHistory, error) {
	var history response.SessionCustomHistory
	if err := r.db.Model(&model.VaccineHistory{}).Where("id_booking = ?", id).First(&history).Error; err != nil {
		return history, err
	}
	return history, nil
}

func (r *historyRepository) GetHistoryByIdBooking(id string) ([]model.VaccineHistory, error) {
	var history []model.VaccineHistory

	if err := r.db.Preload("User.Address").Where("id_booking = ?", id).Find(&history).Error; err != nil {
		return history, err
	}

	return history, nil
}

func (r *historyRepository) GetHistoryByIdSameBook(id string) ([]model.VaccineHistory, error) {
	var history []model.VaccineHistory

	if err := r.db.Preload("User.Address").Preload("Booking.Session").Where("id_same_book = ?", id).Find(&history).Error; err != nil {
		return history, err
	}

	return history, nil
}

func (r *historyRepository) GetHistoryByNIK(id, nik string) (model.VaccineHistory, error) {
	var history model.VaccineHistory

	if err := r.db.Preload("User.Address").Where("nik_user = ? AND id_booking = ?", nik, id).First(&history).Error; err != nil {
		return history, err
	}

	return history, nil
}

func (r *historyRepository) GetHistoriesByNIK(nik string) ([]model.VaccineHistory, error) {
	var history []model.VaccineHistory

	if err := r.db.Preload("User.Address").Where("nik_user = ?", nik).Find(&history).Error; err != nil {
		return history, err
	}

	return history, nil
}

func (r *historyRepository) GetHistoriesByIdBooking(id string) ([]model.VaccineHistory, error) {
	var history []model.VaccineHistory

	if err := r.db.Preload("User.Address").Where("id_booking = ?", id).Find(&history).Error; err != nil {
		return history, err
	}

	return history, nil
}

func (r *historyRepository) UpdateHistory(data model.VaccineHistory, id string) (model.VaccineHistory, error) {
	var history model.VaccineHistory
	if err := r.db.Model(&model.VaccineHistory{}).Where("id = ?", id).Updates(&data).Error; err != nil {
		return history, err
	}
	return history, nil
}

func (r *historyRepository) UpdateHistoryByNik(data model.VaccineHistory, nik, id string) (model.VaccineHistory, error) {
	var history model.VaccineHistory

	if err := r.db.Model(&history).Where("nik_user  = ? AND id_booking = ?", nik, id).Updates(&data).Error; err != nil {
		return history, err
	}

	return history, nil
}

func (r *historyRepository) CheckVaccineCount(nik string) ([]model.VaccineHistory, error) {
	var history []model.VaccineHistory

	if err := r.db.Model(&history).Where("nik_user = ? AND status = ?", nik, "Attended").Find(&history).Error; err != nil {
		return history, err
	}

	return history, nil
}

func (r *historyRepository) GetTotalUserVaccinated() (response.VaccinatedUser, error) {
	var history response.VaccinatedUser

	if err := r.db.Raw("SELECT id, COUNT(DISTINCT nik_user) AS vaccinated FROM vaccine_histories WHERE status = ?", "Attended").Scan(&history).Error; err != nil {
		return history, err
	}

	return history, nil
}
