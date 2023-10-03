package users

import (
	"context"
	"fmt"
	"github.com/labstack/echo/v4"
	"github.com/superosystem/SewaKantor/backend/src/applications/middlewares"
	"github.com/superosystem/SewaKantor/backend/src/commons"
	"github.com/superosystem/SewaKantor/backend/src/domains/users"
	"github.com/superosystem/SewaKantor/backend/src/infrastructures/storage"
	ctrl "github.com/superosystem/SewaKantor/backend/src/interfaces/http/api"
	"github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/users/request"
	"github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/users/response"
	"log"
	"net/http"

	"github.com/golang-jwt/jwt"
	passwordvalidator "github.com/wagslane/go-password-validator"
)

type AuthController struct {
	authUsecase  users.Usecase
	cloudStorage storage.CloudinaryConfiguration
}

func NewAuthController(authUC users.Usecase, cs storage.CloudinaryConfiguration) *AuthController {
	return &AuthController{
		authUsecase:  authUC,
		cloudStorage: cs,
	}
}

func (ac *AuthController) HelloMessage(c echo.Context) error {
	return c.String(http.StatusOK, "Hello there! This is Staging API for Better Space. Better Space is an Office Booking System Alterra Capstone Project Batch 3 by Group 3. Please refer to the documentation for details about all of the requests.")
}

func (ac *AuthController) Register(c echo.Context) error {
	userInput := request.User{}

	if err := c.Bind(&userInput); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "invalid request")
	}

	err := userInput.Validate()

	if err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "validation failed")
	}

	// confirm password input
	if userInput.Password != userInput.ConfirmationPassword {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "password and confirmation password do not match")
	}

	const minEntropyBits = 30
	err = passwordvalidator.Validate(userInput.Password, minEntropyBits)

	if err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", fmt.Sprintf("%s", err))
	}

	user := ac.authUsecase.Register(userInput.ToDomainRegister())

	if user.ID == 0 {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "email already taken, please use another email or process to login")
	}

	return ctrl.NewResponse(c, http.StatusCreated, "success", "account created", response.FromDomain(user))
}

func (ac *AuthController) Login(c echo.Context) error {
	userInput := request.UserLogin{}

	if err := c.Bind(&userInput); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "invalid request")
	}

	err := userInput.Validate()

	if err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "validation failed")
	}

	token := ac.authUsecase.Login(userInput.ToDomainLogin())

	if token["access_token"] == "" {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "invalid email or password")
	}

	return c.JSON(http.StatusOK, map[string]any{
		"access_token":  token["access_token"],
		"refresh_token": token["refresh_token"],
	})
}

func (ac *AuthController) Token(c echo.Context) error {
	refreshTokenInput := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckRefreshToken(refreshTokenInput.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid refresh token")
	}

	payload := commons.GetPayloadInfo(c)
	id := payload.ID
	getUser := ac.authUsecase.GetByID(id)

	if getUser.ID == 0 {
		return ctrl.NewInfoResponse(c, http.StatusNotFound, "failed", "user not found")
	}

	newTokenPair := ac.authUsecase.Token(id, getUser.Roles)

	if newTokenPair["access_token"] == "" {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid email or password")
	}

	middlewares.Logout(refreshTokenInput.Raw)

	return c.JSON(http.StatusOK, map[string]any{
		"access_token":  newTokenPair["access_token"],
		"refresh_token": newTokenPair["refresh_token"],
	})
}

func (ac *AuthController) GetAll(c echo.Context) error {
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

	users := []response.User{}

	usersData := ac.authUsecase.GetAll()

	for _, user := range usersData {
		users = append(users, response.FromDomain(user))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "all users", users)
}

func (ac *AuthController) GetByID(c echo.Context) error {
	var user users.Domain
	token := c.Get("user").(*jwt.Token)
	paramsId := c.Param("id")

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	user = ac.authUsecase.GetByID(paramsId)

	if user.ID == 0 {
		return ctrl.NewInfoResponse(c, http.StatusNotFound, "failed", "user not found")
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "user found", response.FromDomain(user))
}

func (ac *AuthController) GetProfile(c echo.Context) error {
	var user users.Domain
	token := c.Get("user").(*jwt.Token)
	payload := commons.GetPayloadInfo(c)
	userId := payload.ID

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	user = ac.authUsecase.GetByID(userId)

	if user.ID == 0 {
		return ctrl.NewInfoResponse(c, http.StatusNotFound, "failed", "user not found")
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "user found", response.FromDomain(user))
}

func (ac *AuthController) Delete(c echo.Context) error {
	var isSuccess bool
	token := c.Get("user").(*jwt.Token)
	payload := commons.GetPayloadInfo(c)
	role := payload.Roles
	userId := payload.ID
	paramsId := c.Param("id")

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	if role == "admin" {
		isSuccess = ac.authUsecase.Delete(paramsId)
	} else if role == "user" {
		isSuccess = ac.authUsecase.Delete(userId)
	}

	if !isSuccess {
		return ctrl.NewInfoResponse(c, http.StatusNotFound, "failed", "user not found")
	}

	return ctrl.NewInfoResponse(c, http.StatusOK, "success", "user deleted")
}

func (ac *AuthController) UpdateProfilePhoto(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)
	payload := commons.GetPayloadInfo(c)
	role := payload.Roles
	userId := payload.ID
	paramsId := c.Param("id")
	var getUser users.Domain
	var isSuccess bool
	var url string
	var err error

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	input := request.UserPhoto{}

	if err := c.Bind(&input); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "validation failed")
	}

	fileInput, err := c.FormFile("photo")

	// validating input
	switch err {
	case nil:
		// do nothing
	case http.ErrMissingFile:
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "no file attached")
	default:
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "bind failed")
	}

	isFileAllowed, isFileAllowedMessage := commons.IsFileAllowed(fileInput)

	if !isFileAllowed {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", isFileAllowedMessage)
	}

	src, err := fileInput.Open()

	if err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "bind failed")
	}

	defer src.Close()

	ctx := context.Background()

	if role == "admin" {
		getUser = ac.authUsecase.GetByID(paramsId)
	} else if role == "user" {
		getUser = ac.authUsecase.GetByID(userId)
	}

	if getUser.ID == 0 {
		return ctrl.NewInfoResponse(c, http.StatusNotFound, "failed", "user not found")
	}

	if role == "user" {
		url, err = ac.cloudStorage.CloudinaryUpload(ctx, src, userId)
	} else if role == "admin" {
		url, err = ac.cloudStorage.CloudinaryUpload(ctx, src, paramsId)
	}

	if err != nil {
		log.Println(err)
		return ctrl.NewInfoResponse(c, http.StatusConflict, "failed", "upload to cloudinary failed")
	}

	input.Photo = url

	if err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "validation failed")
	}

	if role == "admin" {
		isSuccess = ac.authUsecase.UpdateProfilePhoto(paramsId, input.ToDomainPhoto())
	} else {
		isSuccess = ac.authUsecase.UpdateProfilePhoto(userId, input.ToDomainPhoto())
	}

	if !isSuccess {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "failed to update")
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "profile photo updated", url)
}

func (ac *AuthController) UpdateProfileData(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)
	payload := commons.GetPayloadInfo(c)
	role := payload.Roles
	userId := payload.ID
	paramsId := c.Param("id")
	var userData users.Domain

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	if role == "admin" {
		userData = ac.authUsecase.GetByID(paramsId)
	} else if role == "user" {
		userData = ac.authUsecase.GetByID(userId)
	}

	if userData.ID == 0 {
		return ctrl.NewInfoResponse(c, http.StatusNotFound, "failed", "user not found")
	}

	input := request.User{}

	if err := c.Bind(&input); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "bind failed")
	}

	if input.Email == "" && input.FullName == "" && input.Gender == "" {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "please input body request")
	}

	// fill other entity with existed data
	input.Password = userData.Password
	input.ConfirmationPassword = userData.Password
	input.Roles = userData.Roles
	input.Photo = userData.Photo

	err := input.Validate()

	if err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "validation failed, check body request")
	}

	if role == "user" {
		userData = ac.authUsecase.UpdateProfileData(userId, input.ToDomainRegister())
	} else if role == "admin" {
		userData = ac.authUsecase.UpdateProfileData(paramsId, input.ToDomainRegister())
	}

	// return failed if email already used
	if userData.ID == 0 {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "email already used by another account, please use another email")
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "profile updated", response.FromDomain(userData))
}

func (ac *AuthController) SearchByEmail(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)
	payload := commons.GetPayloadInfo(c)
	role := payload.Roles
	var email string = c.QueryParam("search")

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	// only admin allowed
	if role != "admin" {
		return ctrl.NewInfoResponse(c, http.StatusForbidden, "forbidden", "not allowed to access this info")
	}

	user := ac.authUsecase.SearchByEmail(email)

	if user.ID == 0 {
		return ctrl.NewInfoResponse(c, http.StatusNotFound, "failed", fmt.Sprintf("user with email %s not found", email))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", fmt.Sprintf("user with email %s found", email), response.FromDomain(user))
}

func (ac *AuthController) Logout(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	middlewares.Logout(token.Raw)

	return ctrl.NewInfoResponse(c, http.StatusOK, "success", "logout success")
}
