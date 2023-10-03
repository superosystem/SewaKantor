package transactions

import (
	"github.com/superosystem/SewaKantor/backend/src/domains/transactions"

	"gorm.io/gorm"
)

type TransactionRepository struct {
	conn *gorm.DB
}

func NewMySQLRepository(conn *gorm.DB) transactions.Repository {
	return &TransactionRepository{
		conn: conn,
	}
}

func (t *TransactionRepository) GetAll() []transactions.Domain {
	var rec []Transaction

	t.conn.Preload("User", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		Preload("Office", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		Find(&rec)

	var TransactionDomain []transactions.Domain

	for _, trans := range rec {
		TransactionDomain = append(TransactionDomain, trans.ToDomain())
	}

	return TransactionDomain
}

func (t *TransactionRepository) GetByUserID(userId string) []transactions.Domain {
	var rec []Transaction

	t.conn.Preload("User", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		Preload("Office", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		Where("user_id = ?", userId).
		Find(&rec)

	TransactionDomain := []transactions.Domain{}

	for _, trans := range rec {
		TransactionDomain = append(TransactionDomain, trans.ToDomain())
	}

	return TransactionDomain
}

func (t *TransactionRepository) GetByOfficeID(officeId string) []transactions.Domain {
	var rec []Transaction

	t.conn.Preload("User", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		Preload("Office", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		Where("office_id = ?", officeId).
		Find(&rec)

	TransactionDomain := []transactions.Domain{}

	for _, trans := range rec {
		TransactionDomain = append(TransactionDomain, trans.ToDomain())
	}

	return TransactionDomain
}

func (t *TransactionRepository) Create(TransactionDomain *transactions.Domain) transactions.Domain {
	rec := FromDomain(TransactionDomain)

	result := t.conn.Preload("User").Preload("Office").Create(&rec)

	result.Last(&rec)

	return rec.ToDomain()
}

func (t *TransactionRepository) GetByID(id string) transactions.Domain {
	var transaction Transaction

	t.conn.Preload("User", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		Preload("Office", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		First(&transaction, "id = ?", id)

	return transaction.ToDomain()
}

func (t *TransactionRepository) Update(id string, transactionDomain *transactions.Domain) transactions.Domain {
	transaction := t.GetByID(id)

	updatedTransaction := FromDomain(&transaction)

	updatedTransaction.Status = transactionDomain.Status

	t.conn.Preload("User", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		Preload("Office", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		Save(&updatedTransaction)

	// get again for updated data
	latest := t.GetByID(id)

	return latest
}

func (t *TransactionRepository) Delete(id string) bool {
	var transaction = t.GetByID(id)

	deletedTransaction := FromDomain(&transaction)

	result := t.conn.Delete(&deletedTransaction)

	return result.RowsAffected != 0
}

func (t *TransactionRepository) TotalTransactions() int {
	var count int64

	t.conn.Table("transactions").Not(map[string]interface{}{"status": []string{"rejected", "cancelled"}}).Count(&count)

	return int(count)
}

func (t *TransactionRepository) TotalTransactionsByOfficeID(officeId string) int {
	var count int64

	t.conn.Table("transactions").Not(map[string]interface{}{"status": []string{"rejected", "cancelled"}}).Where("office_id = ?", officeId).Count(&count)

	return int(count)
}
