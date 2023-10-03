package transactions

import (
	"strconv"
	"time"
)

type transactionUsecase struct {
	transactionRepository Repository
}

func NewTransactionUsecase(tr Repository) Usecase {
	return &transactionUsecase{
		transactionRepository: tr,
	}
}

func (tu *transactionUsecase) GetAll() []Domain {
	return tu.transactionRepository.GetAll()
}

func (tu *transactionUsecase) Create(transactionDomain *Domain) Domain {
	unixCheckIn := transactionDomain.CheckIn.Unix()
	duration := int(unixCheckIn) + (transactionDomain.Duration * 3600)
	checkOutTimestamp := time.Unix(int64(duration), 0)
	transactionDomain.CheckOut = checkOutTimestamp

	return tu.transactionRepository.Create(transactionDomain)
}

func (tu *transactionUsecase) GetByID(id string) Domain {
	return tu.transactionRepository.GetByID(id)
}

func (tu *transactionUsecase) GetByUserID(userId string) []Domain {
	return tu.transactionRepository.GetByUserID(userId)
}

func (tu *transactionUsecase) AdminGetByUserID(userId string) []Domain {
	return tu.transactionRepository.GetByUserID(userId)
}

func (tu *transactionUsecase) GetByOfficeID(officeId string) []Domain {
	return tu.transactionRepository.GetByOfficeID(officeId)
}

func (tu *transactionUsecase) Update(id string, status string) Domain {
	transaction := tu.transactionRepository.GetByID(id)

	if transaction.ID == 0 {
		return transaction
	}

	transaction.Status = status

	return tu.transactionRepository.Update(id, &transaction)
}

func (tu *transactionUsecase) Delete(id string) bool {
	return tu.transactionRepository.Delete(id)
}

func (tu *transactionUsecase) Cancel(transactionId string, userId string) Domain {
	transaction := tu.transactionRepository.GetByID(transactionId)

	if userId != strconv.Itoa(int(transaction.UserID)) {
		transaction.UserID = 0
		return transaction
	}

	transaction.Status = "cancelled"

	return tu.transactionRepository.Update(transactionId, &transaction)
}

func (tu *transactionUsecase) TotalTransactions() int {
	return tu.transactionRepository.TotalTransactions()
}

func (tu *transactionUsecase) TotalTransactionsByOfficeID(officeId string) int {
	return tu.transactionRepository.TotalTransactionsByOfficeID(officeId)
}
