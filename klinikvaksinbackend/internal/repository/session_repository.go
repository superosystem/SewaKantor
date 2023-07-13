package repository

import (
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/dto/response"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type SessionRepository interface {
	CreateSession(data model.Session) (model.Session, error)
	GetAllSessions() ([]model.Session, error)
	GetSumOfCapacity(id string) (response.SessionSumCap, error)
	GetSessionById(id string) (model.Session, error)
	GetSessionsByAdmin(auth string) ([]model.Session, error)
	GetAllFinishedSessionCount() (response.SessionFinished, error)
	UpdateSession(data model.Session, id string) error
	CloseSession(data model.Session, id string) error
	DeleteSession(id string) error
	IsCloseFalse() (response.IsCloseFalse, error)
}

type sessionRepository struct {
	db *gorm.DB
}

func NewSessionsRepository(db *gorm.DB) *sessionRepository {
	return &sessionRepository{db: db}
}

func (r *sessionRepository) CreateSession(data model.Session) (model.Session, error) {
	var session model.Session

	if err := r.db.Create(&data).Error; err != nil {
		return session, err
	}

	return data, nil
}

func (r *sessionRepository) GetAllSessions() ([]model.Session, error) {
	var session []model.Session

	if err := r.db.Preload(clause.Associations).Preload("Booking." + clause.Associations).Preload("Vaccine").Model(&model.Session{}).Find(&session).Error; err != nil {
		return session, err
	}

	return session, nil
}

func (r *sessionRepository) GetSumOfCapacity(id string) (response.SessionSumCap, error) {
	var session response.SessionSumCap

	if err := r.db.Preload("Vaccine").Raw("SELECT id, SUM(capacity) AS total_capacity FROM sessions WHERE id_vaccine = ?", id).Scan(&session).Error; err != nil {
		return session, err
	}

	return session, nil
}

func (r *sessionRepository) GetSessionById(id string) (model.Session, error) {
	var session model.Session

	if err := r.db.Preload("Vaccine").Preload("Booking.User.Address").Where("id = ?", id).First(&session).Error; err != nil {
		return session, err
	}

	return session, nil
}

func (r *sessionRepository) GetAllFinishedSessionCount() (response.SessionFinished, error) {
	var session response.SessionFinished

	if err := r.db.Raw("SELECT id, COUNT(is_close) AS amount FROM sessions WHERE is_close = ?", true).Scan(&session).Error; err != nil {
		return session, err
	}

	return session, nil
}

func (r *sessionRepository) GetSessionsByAdmin(auth string) ([]model.Session, error) {
	var session []model.Session

	if err := r.db.Preload(clause.Associations).Preload("Booking."+clause.Associations).Preload("Vaccine").Joins("Vaccine").Where("Vaccine.id_health_facilities = ?", auth).Find(&session).Error; err != nil {
		return session, err
	}

	return session, nil
}

func (r *sessionRepository) UpdateSession(data model.Session, id string) error {
	if err := r.db.Preload("Vaccine").Model(&model.Session{}).Where("id = ?", id).Updates(&data).Error; err != nil {
		return err
	}

	return nil
}

func (r *sessionRepository) CloseSession(data model.Session, id string) error {
	if err := r.db.Preload("Vaccine").Model(&model.Session{}).Where("id = ?", id).Updates(&data).Error; err != nil {
		return err
	}

	return nil
}

func (r *sessionRepository) DeleteSession(id string) error {
	var session model.Session

	if err := r.db.Where("id = ?", id).Delete(&session).Error; err != nil {
		return err
	}

	return nil
}

func (r *sessionRepository) IsCloseFalse() (response.IsCloseFalse, error) {
	var active response.IsCloseFalse

	var count int64

	r.db.Model(&model.Session{}).Where("is_close = ?", false).Count(&count)

	active.Active = int(count)

	return active, nil
}
