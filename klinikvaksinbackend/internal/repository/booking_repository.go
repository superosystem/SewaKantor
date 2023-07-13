package repository

import (
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type BookingRepository interface {
	CreateBooking(data model.BookingSession) error
	UpdateBooking(data model.BookingSession) error
	UpdateBookingAcc(data model.BookingSession) (model.BookingSession, error)
	GetAllBooking() ([]model.BookingSession, error)
	GetBooking(id string) (model.BookingSession, error)
	GetBookingBySession(id string) ([]model.BookingSession, error)
	GetAllBookingBySession(id string) ([]model.BookingSession, error)
	GetBookingBySessionDen(id string) ([]model.BookingSession, error)
	FindMaxQueue(id_session string) (model.BookingSession, error)
	DeleteBooking(id string) error
}

type bookingRepository struct {
	db *gorm.DB
}

func NewBookingRepository(db *gorm.DB) *bookingRepository {
	return &bookingRepository{db: db}
}

func (r *bookingRepository) CreateBooking(data model.BookingSession) error {
	if err := r.db.Save(&data).Error; err != nil {
		return err
	}

	return nil
}

func (r *bookingRepository) UpdateBooking(data model.BookingSession) error {
	var booking model.BookingSession

	if err := r.db.Preload("Session.Vaccine").Preload("History").Model(&booking).Where("id_session = ? AND id = ?", data.IdSession, data.ID).Updates(&data).Error; err != nil {
		return err
	}

	return nil
}

func (r *bookingRepository) UpdateBookingAcc(data model.BookingSession) (model.BookingSession, error) {
	var booking model.BookingSession

	if err := r.db.Preload("Session.Vaccine").Preload("History").Model(&booking).Where("id = ? AND nik_user = ?", data.ID, data.NikUser).Updates(&data).Error; err != nil {
		return booking, err
	}

	return booking, nil
}

func (r *bookingRepository) GetAllBooking() ([]model.BookingSession, error) {
	var booking []model.BookingSession

	if err := r.db.Preload(clause.Associations).Preload("Session.Vaccine").Preload("History." + clause.Associations).Model(&model.BookingSession{}).Find(&booking).Error; err != nil {
		return booking, err
	}

	return booking, nil
}

func (r *bookingRepository) GetBooking(id string) (model.BookingSession, error) {
	var booking model.BookingSession

	if err := r.db.Preload("Session.Vaccine").Where("id = ?", id).First(&booking).Error; err != nil {
		return booking, err
	}

	return booking, nil
}

func (r *bookingRepository) GetAllBookingBySession(id string) ([]model.BookingSession, error) {
	var booking []model.BookingSession

	if err := r.db.Preload("Session.Vaccine").Preload("User").Where("id_session = ? AND NOT status = ?", id, "Rejected").Find(&booking).Error; err != nil {
		return booking, err
	}

	return booking, nil
}

func (r *bookingRepository) GetBookingBySession(id string) ([]model.BookingSession, error) {
	var booking []model.BookingSession

	if err := r.db.Preload("Session.Vaccine").Where("id_session = ? AND NOT status = ?", id, "Rejected").Find(&booking).Error; err != nil {
		return booking, err
	}

	return booking, nil
}

func (r *bookingRepository) GetBookingBySessionDen(id string) ([]model.BookingSession, error) {
	var booking []model.BookingSession

	if err := r.db.Preload("Session.Vaccine").Where("id_session = ? AND NOT status = ?", id, "Rejected").Find(&booking).Error; err != nil {
		return booking, err
	}

	return booking, nil
}

func (r *bookingRepository) FindMaxQueue(id_session string) (model.BookingSession, error) {
	var booking model.BookingSession

	if err := r.db.Model(&booking).Where("id_session = ?", id_session).Order("queue desc").First(&booking).Error; err != nil {
		return booking, err
	}

	return booking, nil
}

func (r *bookingRepository) DeleteBooking(id string) error {
	var booking model.BookingSession

	if err := r.db.Where("id = ?", id).Delete(&booking).Error; err != nil {
		return err
	}

	return nil
}
