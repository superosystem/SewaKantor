package review

import (
	"fmt"
	"github.com/labstack/echo/v4"
	"github.com/superosystem/SewaKantor/backend/src/applications/middlewares"
	_utils "github.com/superosystem/SewaKantor/backend/src/commons"
	"github.com/superosystem/SewaKantor/backend/src/domains/review"
	ctrl "github.com/superosystem/SewaKantor/backend/src/interfaces/http/api"
	"github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/review/request"
	"github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/review/response"
	"net/http"
	"strconv"

	"github.com/golang-jwt/jwt"
)

type ReviewController struct {
	ReviewUsecase review.Usecase
}

func NewReviewController(rc review.Usecase) *ReviewController {
	return &ReviewController{
		ReviewUsecase: rc,
	}
}

func (r *ReviewController) GetAll(c echo.Context) error {
	ReviewsData := r.ReviewUsecase.GetAll()

	Reviews := []response.Review{}

	for _, rev := range ReviewsData {
		Reviews = append(Reviews, response.FromDomain(rev))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "all review", Reviews)
}

func (r *ReviewController) Create(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	input := request.Review{}

	if err := c.Bind(&input); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "validation failed")
	}

	payload := _utils.GetPayloadInfo(c)
	role := payload.Roles

	if role == "user" {
		intUserID, _ := strconv.Atoi(payload.ID)
		input.UserID = uint(intUserID)
	}

	err := input.Validate()

	if err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", fmt.Sprintf("validation failed, %s", err))
	}

	rev := r.ReviewUsecase.Create(input.ToDomain())

	if rev.ID == 0 {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "create review failed")
	}

	return ctrl.NewResponse(c, http.StatusCreated, "success", "review created", response.FromDomain(rev))
}

func (r *ReviewController) GetByID(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)
	payload := _utils.GetPayloadInfo(c)
	userId := payload.ID
	role := payload.Roles

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	var id string = c.Param("id")

	review := r.ReviewUsecase.GetByID(id)

	if review.ID == 0 {
		return ctrl.NewResponse(c, http.StatusNotFound, "failed", "review not found", "")
	}

	if role == "user" {
		if strconv.Itoa(int(review.UserID)) != userId {
			return ctrl.NewInfoResponse(c, http.StatusForbidden, "failed", "not allowed to access other user review")
		}
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "review found", response.FromDomain(review))
}

func (r *ReviewController) Update(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	var reviewId string = c.Param("id")

	input := request.Review{}

	if err := c.Bind(&input); err != nil {
		return ctrl.NewResponse(c, http.StatusBadRequest, "failed", "bind failed", "")
	}

	payload := _utils.GetPayloadInfo(c)
	role := payload.Roles

	if role == "user" {
		intUserID, _ := strconv.Atoi(payload.ID)
		input.UserID = uint(intUserID)
	}

	err := input.Validate()

	if err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", fmt.Sprintf("validation failed, %s", err))
	}

	review := r.ReviewUsecase.Update(reviewId, input.ToDomain())

	if review.ID == 0 {
		return ctrl.NewInfoResponse(c, http.StatusNotFound, "failed", "review not found")
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "review updated", response.FromDomain(review))
}

func (r *ReviewController) Delete(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	payload := _utils.GetPayloadInfo(c)
	role := payload.Roles

	if role != "admin" {
		return ctrl.NewInfoResponse(c, http.StatusForbidden, "forbidden", "not allowed to access this info")
	}

	var reviewId string = c.Param("id")

	isSuccess := r.ReviewUsecase.Delete(reviewId)

	if !isSuccess {
		return ctrl.NewResponse(c, http.StatusNotFound, "failed", "review not found", "")
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "review deleted", "")
}

func (r *ReviewController) GetByUserID(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)
	payload := _utils.GetPayloadInfo(c)
	userId := payload.ID

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	ReviewData := r.ReviewUsecase.GetByUserID(userId)

	Review := []response.Review{}

	for _, rev := range ReviewData {
		Review = append(Review, response.FromDomain(rev))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "all review by user ID : "+userId, Review)
}

func (r *ReviewController) AdminGetByUserID(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)
	var userId string = c.Param("user_id")
	payload := _utils.GetPayloadInfo(c)
	role := payload.Roles

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	if role != "admin" {
		return ctrl.NewInfoResponse(c, http.StatusForbidden, "failed", "not allowed to access this info")
	}

	ReviewData := r.ReviewUsecase.GetByUserID(userId)

	Review := []response.Review{}

	for _, rev := range ReviewData {
		Review = append(Review, response.FromDomain(rev))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "all review by user ID : "+userId, Review)
}

func (r *ReviewController) GetByOfficeID(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)
	var officeId string = c.Param("office_id")

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	ReviewData := r.ReviewUsecase.GetByOfficeID(officeId)

	Review := []response.Review{}

	for _, rev := range ReviewData {
		Review = append(Review, response.FromDomain(rev))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "all review by office ID : "+officeId, Review)
}
