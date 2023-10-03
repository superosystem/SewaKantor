package review

import (
	"fmt"
	"github.com/superosystem/SewaKantor/backend/src/domains/review"

	"gorm.io/gorm"
)

type ReviewRepository struct {
	conn *gorm.DB
}

func NewMySQLRepository(conn *gorm.DB) review.Repository {
	return &ReviewRepository{
		conn: conn,
	}
}

func (r *ReviewRepository) GetAll() []review.Domain {
	var rec []Review

	r.conn.Preload("User", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		Preload("Office", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		Find(&rec)

	ReviewDomain := []review.Domain{}

	for _, rev := range rec {
		ReviewDomain = append(ReviewDomain, rev.ToDomain())
	}

	return ReviewDomain
}

func (r *ReviewRepository) Create(ReviewDomain *review.Domain) review.Domain {
	rec := FromDomain(ReviewDomain)

	result := r.conn.Preload("User").Preload("Office").Create(&rec)

	result.Last(&rec)

	return rec.ToDomain()
}

func (r *ReviewRepository) GetByID(id string) review.Domain {
	var review Review

	r.conn.Preload("User", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		Preload("Office", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		First(&review, "id = ?", id)

	return review.ToDomain()
}

func (r *ReviewRepository) Update(id string, reviewDomain *review.Domain) review.Domain {
	review := r.GetByID(id)
	updatedReview := FromDomain(&review)

	var getUserID uint
	r.conn.Raw("SELECT ID FROM `users` WHERE `id` = ?", reviewDomain.UserID).Scan(&getUserID)
	fmt.Println("user id", getUserID)

	if getUserID == 0 {
		updatedReview.ID = 0
		return updatedReview.ToDomain()
	}

	var getOfficeID uint
	r.conn.Raw("SELECT ID FROM `offices` WHERE `id` = ?", reviewDomain.OfficeID).Scan(&getOfficeID)
	fmt.Println("office id", getOfficeID)

	if getOfficeID == 0 {
		updatedReview.ID = 0
		return updatedReview.ToDomain()
	}

	updatedReview.Score = reviewDomain.Score
	updatedReview.Comment = reviewDomain.Comment

	updatedReview.UserID = reviewDomain.UserID
	updatedReview.OfficeID = reviewDomain.OfficeID

	r.conn.Preload("User", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		Preload("Office", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		Save(&updatedReview)

	return updatedReview.ToDomain()
}

func (r *ReviewRepository) Delete(id string) bool {
	var review = r.GetByID(id)

	deletedReview := FromDomain(&review)

	result := r.conn.Delete(&deletedReview)

	return result.RowsAffected != 0
}

func (r *ReviewRepository) GetByUserID(userId string) []review.Domain {
	var rec []Review

	r.conn.Preload("User", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		Preload("Office", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		Where("user_id = ?", userId).
		Find(&rec)

	ReviewDomain := []review.Domain{}

	for _, rev := range rec {
		ReviewDomain = append(ReviewDomain, rev.ToDomain())
	}

	return ReviewDomain
}

func (r *ReviewRepository) GetByOfficeID(officeId string) []review.Domain {
	var rec []Review

	r.conn.Preload("User", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		Preload("Office", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		Where("office_id = ?", officeId).
		Find(&rec)

	ReviewDomain := []review.Domain{}

	for _, rev := range rec {
		ReviewDomain = append(ReviewDomain, rev.ToDomain())
	}

	return ReviewDomain
}
