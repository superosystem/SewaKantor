package service

import (
	"errors"

	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/dto/payload"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/dto/response"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/middleware"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/repository"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/util"
)

type AdminService interface {
	LoginAdmin(payloads payload.Login) (response.Login, error)
	GetAllAdmins() ([]response.AdminResponse, error)
	GetAdmin(id string) (response.AdminResponse, error)
	UpdateAdmin(payloads payload.AdminPayload, id string) (response.AdminProfileResponse, error)
	DeleteAdmin(id string) error
}

type adminService struct {
	AdminRepo repository.AdminRepository
}

func NewAdminService(adminRepo repository.AdminRepository) *adminService {
	return &adminService{
		AdminRepo: adminRepo,
	}
}

func (s *adminService) LoginAdmin(payloads payload.Login) (response.Login, error) {
	var loginResponse response.Login

	adminModel := model.Admin{
		Email:    payloads.Email,
		Password: payloads.Password,
	}

	adminData, err := s.AdminRepo.LoginAdmin(adminModel)
	if err != nil {
		return loginResponse, err
	}

	isValid := util.CheckPasswordHash(payloads.Password, adminData.Password)
	if !isValid {
		return loginResponse, errors.New("wrong password")
	}

	token, errToken := middleware.CreateTokenAdmin(adminData.ID, adminData.IdHealthFacilities, adminData.Email)

	if errToken != nil {
		return loginResponse, err
	}

	loginResponse = response.Login{
		Token: token,
	}

	return loginResponse, nil
}

func (s *adminService) GetAllAdmins() ([]response.AdminResponse, error) {
	var adminResponse []response.AdminResponse

	getData, err := s.AdminRepo.GetAllAdmin()
	if err != nil {
		return adminResponse, err
	}

	adminResponse = make([]response.AdminResponse, len(getData))

	for i, data := range getData {
		adminResponse[i] = response.AdminResponse{
			ID:                 data.ID,
			IdHealthFacilities: data.IdHealthFacilities,
			Email:              data.Email,
			CreatedAt:          data.CreatedAt,
			UpdatedAt:          data.UpdatedAt,
		}
	}

	return adminResponse, nil
}

func (s *adminService) GetAdmin(id string) (response.AdminResponse, error) {
	var responseAdmin response.AdminResponse

	getData, err := s.AdminRepo.GetAdmins(id)

	if err != nil {
		return responseAdmin, err
	}

	responseAdmin = response.AdminResponse{
		ID:                 getData.ID,
		IdHealthFacilities: getData.IdHealthFacilities,
		Email:              getData.Email,
		CreatedAt:          getData.CreatedAt,
		UpdatedAt:          getData.UpdatedAt,
	}

	return responseAdmin, nil
}

func (s *adminService) UpdateAdmin(payloads payload.AdminPayload, id string) (response.AdminProfileResponse, error) {
	var dataResp response.AdminProfileResponse
	hashPass, err := util.HashPassword(payloads.Password)
	if err != nil {
		return dataResp, err
	}

	adminData := model.Admin{
		IdHealthFacilities: payloads.IdHealthFacilities,
		Email:              payloads.Email,
		Password:           hashPass,
	}

	dataResp = response.AdminProfileResponse{
		ID:    id,
		Email: payloads.Email,
	}

	if err := s.AdminRepo.UpdateAdmin(adminData, id); err != nil {
		return dataResp, err
	}
	return dataResp, nil
}

func (s *adminService) DeleteAdmin(id string) error {

	if err := s.AdminRepo.DeleteAdmin(id); err != nil {
		return err
	}

	return nil
}
