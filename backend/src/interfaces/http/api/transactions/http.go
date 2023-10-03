package transactions

import (
	"fmt"
	"github.com/labstack/echo/v4"
	"github.com/superosystem/SewaKantor/backend/src/applications/middlewares"
	"github.com/superosystem/SewaKantor/backend/src/commons"
	"github.com/superosystem/SewaKantor/backend/src/domains/transactions"
	ctrl "github.com/superosystem/SewaKantor/backend/src/interfaces/http/api"
	"github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/transactions/request"
	"github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/transactions/response"
	"net/http"
	"strconv"

	"github.com/golang-jwt/jwt"
)

type TransactionController struct {
	TransactionUsecase transactions.Usecase
}

func NewTransactionController(tc transactions.Usecase) *TransactionController {
	return &TransactionController{
		TransactionUsecase: tc,
	}
}

func (t *TransactionController) GetAll(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	TransactionsData := t.TransactionUsecase.GetAll()

	Transactions := []response.Transaction{}

	for _, trans := range TransactionsData {
		Transactions = append(Transactions, response.FromDomain(trans))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "all transactions", Transactions)
}

func (t *TransactionController) GetByUserID(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)
	payload := commons.GetPayloadInfo(c)
	userId := payload.ID

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	TransactionsData := t.TransactionUsecase.GetByUserID(userId)

	Transactions := []response.Transaction{}

	for _, trans := range TransactionsData {
		Transactions = append(Transactions, response.FromDomain(trans))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "all transactions by user ID : "+userId, Transactions)
}

func (t *TransactionController) AdminGetByUserID(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)
	var userId string = c.Param("user_id")
	payload := commons.GetPayloadInfo(c)
	role := payload.Roles

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	if role != "admin" {
		return ctrl.NewInfoResponse(c, http.StatusForbidden, "failed", "not allowed to access this info")
	}

	TransactionsData := t.TransactionUsecase.GetByUserID(userId)

	Transactions := []response.Transaction{}

	for _, trans := range TransactionsData {
		Transactions = append(Transactions, response.FromDomain(trans))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "all transactions by user ID : "+userId, Transactions)
}

func (t *TransactionController) GetByOfficeID(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)
	var officeId string = c.Param("office_id")
	payload := commons.GetPayloadInfo(c)
	role := payload.Roles

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	if role != "admin" {
		return ctrl.NewInfoResponse(c, http.StatusForbidden, "failed", "not allowed to access this info")
	}

	TransactionsData := t.TransactionUsecase.GetByOfficeID(officeId)

	Transactions := []response.Transaction{}

	for _, trans := range TransactionsData {
		Transactions = append(Transactions, response.FromDomain(trans))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "all transactions by office ID : "+officeId, Transactions)
}

func (t *TransactionController) Create(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	input := request.Transaction{}

	if err := c.Bind(&input); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "validation failed")
	}

	checkInDTO := request.CheckInDTO{}

	if err := c.Bind(&checkInDTO); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "bind time failed")
	}

	// input hour validation
	if err := checkInDTO.Validate(); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", fmt.Sprintf("%s", err))
	}

	checkInHour := commons.ConvertStringToShiftTime(checkInDTO.CheckInDate, checkInDTO.CheckInHour)

	input.CheckIn = checkInHour

	payload := commons.GetPayloadInfo(c)
	role := payload.Roles

	if role == "user" {
		intUserID, _ := strconv.Atoi(payload.ID)
		input.UserID = uint(intUserID)
		input.Status = "on process"
	}

	err := input.Validate()

	if err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", fmt.Sprintf("validation failed, %s", err))
	}

	trans := t.TransactionUsecase.Create(input.ToDomain())

	if trans.ID == 0 {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "create transaction failed, user_id or office_id did not exist")
	}

	return ctrl.NewResponse(c, http.StatusCreated, "success", "transaction created", response.FromDomain(trans))
}

func (t *TransactionController) GetByID(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)
	payload := commons.GetPayloadInfo(c)
	userId := payload.ID
	role := payload.Roles

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	var id string = c.Param("id")

	transaction := t.TransactionUsecase.GetByID(id)

	if transaction.ID == 0 {
		return ctrl.NewResponse(c, http.StatusNotFound, "failed", "transaction not found", "")
	}

	if role == "user" {
		if strconv.Itoa(int(transaction.UserID)) != userId {
			return ctrl.NewInfoResponse(c, http.StatusForbidden, "failed", "not allowed to access other user transaction")
		}
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "transaction found", response.FromDomain(transaction))
}

func (t *TransactionController) Update(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	payload := commons.GetPayloadInfo(c)
	role := payload.Roles

	if role != "admin" {
		return ctrl.NewInfoResponse(c, http.StatusForbidden, "forbidden", "not allowed")
	}

	var transactionId string = c.Param("id")

	input := request.StatusDTO{}

	if err := c.Bind(&input); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "bind failed")
	}

	err := input.Validate()

	if err != nil {
		return ctrl.NewErrorResponse(c, http.StatusBadRequest, "failed", "validation failed", err.Error())
	}

	transaction := t.TransactionUsecase.Update(transactionId, input.Status)

	if transaction.ID == 0 {
		return ctrl.NewInfoResponse(c, http.StatusNotFound, "failed", "transaction not found")
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "transaction updated", response.FromDomain(transaction))
}

func (t *TransactionController) Delete(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	payload := commons.GetPayloadInfo(c)
	role := payload.Roles

	if role != "admin" {
		return ctrl.NewInfoResponse(c, http.StatusForbidden, "forbidden", "not allowed to access this info")
	}

	var transactionId string = c.Param("id")

	isSuccess := t.TransactionUsecase.Delete(transactionId)

	if !isSuccess {
		return ctrl.NewResponse(c, http.StatusNotFound, "failed", "transaction not found", "")
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "transaction deleted", "")
}

func (t *TransactionController) Cancel(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	payload := commons.GetPayloadInfo(c)
	role := payload.Roles

	if role != "user" {
		return ctrl.NewInfoResponse(c, http.StatusForbidden, "forbidden", "admin not allowed")
	}

	var transactionId string = c.Param("id")

	userId := payload.ID

	transaction := t.TransactionUsecase.Cancel(transactionId, userId)

	if transaction.ID == 0 {
		return ctrl.NewInfoResponse(c, http.StatusNotFound, "failed", "transaction not found")
	}

	if transaction.UserID == 0 {
		return ctrl.NewInfoResponse(c, http.StatusForbidden, "failed", "not allowed")
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "transaction cancelled", response.FromDomain(transaction))
}

// TotalTransactions() int
func (t *TransactionController) GetTotalTransactions(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	payload := commons.GetPayloadInfo(c)
	role := payload.Roles

	if role != "admin" {
		return ctrl.NewInfoResponse(c, http.StatusForbidden, "forbidden", "admin not allowed")
	}

	totalTransactions := t.TransactionUsecase.TotalTransactions()

	return ctrl.NewResponse(c, http.StatusOK, "success", "total transactions", totalTransactions)
}

// TotalTransactionsByOfficeID(officeId string) int
func (t *TransactionController) GetTotalTransactionsByOfficeID(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	payload := commons.GetPayloadInfo(c)
	role := payload.Roles

	if role != "admin" {
		return ctrl.NewInfoResponse(c, http.StatusForbidden, "forbidden", "admin not allowed")
	}

	var officeId string = c.Param("office_id")

	totalTransactionsPerOffice := t.TransactionUsecase.TotalTransactionsByOfficeID(officeId)

	return ctrl.NewResponse(c, http.StatusOK, "success", "total transactions by office_id = "+officeId, totalTransactionsPerOffice)
}
