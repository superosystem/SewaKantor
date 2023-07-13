package service

import (
	"errors"
	"fmt"
	"sort"
	"time"

	"github.com/google/uuid"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/dto/payload"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/dto/response"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/middleware"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/repository"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/util"
)

type UserService interface {
	RegisterUser(payloads payload.RegisterUser) error
	LoginUser(payloads payload.Login) (response.Login, error)
	GetUserDataByNik(nik string) (response.UserProfile, error)
	GetUserDataByNikNoAddress(nik string) (response.UserProfile, error)
	GetUserHistory(nik string) (response.UserHistory, error)
	GetUserRegisteredDashboard() (response.RegisterStatistic, error)
	UpdateUserProfile(payloads payload.UpdateUser, nik string) (response.UpdateUser, error)
	DeleteUserProfile(nik string) error
	NearbyHealthFacilities(payloads payload.NearbyHealth, nik string) (response.UserNearbyHealth, error)
}

type userService struct {
	UserRepo    repository.UserRepository
	AddressRepo repository.AddressRepository
	HealthRepo  repository.HealthFacilitiesRepository
	HistoryRepo repository.HistoriesRepository
	BookingRepo repository.BookingRepository
	SessionRepo repository.SessionRepository
	VaccineRepo repository.VaccinesRepository
}

func NewUserService(
	userRepo repository.UserRepository,
	addressRepo repository.AddressRepository,
	healthRepo repository.HealthFacilitiesRepository,
	historyRepo repository.HistoriesRepository,
	bookingRepo repository.BookingRepository,
	sessionRepo repository.SessionRepository,
	vaccineRepo repository.VaccinesRepository,
) *userService {
	return &userService{
		UserRepo:    userRepo,
		AddressRepo: addressRepo,
		HealthRepo:  healthRepo,
		HistoryRepo: historyRepo,
		BookingRepo: bookingRepo,
		SessionRepo: sessionRepo,
		VaccineRepo: vaccineRepo,
	}
}

func (s *userService) RegisterUser(payloads payload.RegisterUser) error {

	hashPass, err := util.HashPassword(payloads.Password)
	if err != nil {
		return err
	}

	if payloads.Gender != "P" && payloads.Gender != "L" {
		return errors.New("input gender must P or L")
	}

	defaultVaccineCount := 0

	dateBirth, err := time.Parse("2006-01-02", payloads.BirthDate)
	if err != nil {
		return err
	}
	data, _ := s.UserRepo.CheckExistNik(payloads.NikUser)

	if data.NIK != "" && data.DeletedAt != nil {
		userModel := model.User{
			Email:     payloads.Email,
			Password:  hashPass,
			FullName:  payloads.FullName,
			PhoneNum:  payloads.PhoneNum,
			Gender:    payloads.Gender,
			BirthDate: dateBirth,
		}
		err = s.UserRepo.ReactivatedUser(payloads.NikUser)
		if err != nil {
			return err
		}
		err = s.UserRepo.ReactivatedUpdateUser(userModel, payloads.NikUser)
		if err != nil {
			return err
		}
		err = s.UserRepo.ReactivatedAddress(payloads.NikUser)
		if err != nil {
			return err
		}
		return nil
	}

	userModel := model.User{
		NIK:          payloads.NikUser,
		Email:        payloads.Email,
		Password:     hashPass,
		FullName:     payloads.FullName,
		PhoneNum:     payloads.PhoneNum,
		Gender:       payloads.Gender,
		ProfileImage: nil,
		VaccineCount: defaultVaccineCount,
		BirthDate:    dateBirth,
	}

	errRegis := s.UserRepo.RegisterUser(userModel)
	if errRegis != nil {
		return errRegis
	}

	idAddr := uuid.NewString()

	userAddr := model.Address{
		ID:                 idAddr,
		IdHealthFacilities: nil,
		NikUser:            &payloads.NikUser,
	}

	errAddr := s.AddressRepo.CreateAddress(userAddr)
	if errAddr != nil {
		return errAddr
	}

	return nil
}

func (s *userService) LoginUser(payloads payload.Login) (response.Login, error) {
	var loginResponse response.Login

	userModel := model.User{
		Email:    payloads.Email,
		Password: payloads.Password,
	}

	userData, err := s.UserRepo.LoginUser(userModel)
	if err != nil {
		return loginResponse, err
	}

	isValid := util.CheckPasswordHash(payloads.Password, userData.Password)
	if !isValid {
		return loginResponse, errors.New("wrong password")
	}

	token, errToken := middleware.CreateToken(userData.NIK, userData.Email)

	if errToken != nil {
		return loginResponse, err
	}

	loginResponse = response.Login{
		Token: token,
	}

	return loginResponse, nil
}

func (s *userService) GetUserDataByNik(nik string) (response.UserProfile, error) {
	var responseUser response.UserProfile

	getData, err := s.UserRepo.GetUserDataByNik(nik)
	if err != nil {
		return responseUser, err
	}

	ageUser, err := s.UserRepo.GetAgeUser(getData)
	if err != nil {
		return responseUser, err
	}

	responseUser = response.UserProfile{
		NIK:          getData.NIK,
		Email:        getData.Email,
		FullName:     getData.FullName,
		PhoneNum:     getData.PhoneNum,
		Gender:       getData.Gender,
		VaccineCount: getData.VaccineCount,
		BirthDate:    getData.BirthDate,
		Age:          ageUser.Age,
		Address:      getData.Address,
	}

	return responseUser, nil
}

func (s *userService) GetUserDataByNikNoAddress(nik string) (response.UserProfile, error) {
	var responseUser response.UserProfile

	getData, err := s.UserRepo.GetUserDataByNikNoAddress(nik)
	if err != nil {
		return responseUser, err
	}

	ageUser, err := s.UserRepo.GetAgeUser(getData)
	if err != nil {
		return responseUser, err
	}

	responseUser = response.UserProfile{
		NIK:          getData.NIK,
		Email:        getData.Email,
		FullName:     getData.FullName,
		PhoneNum:     getData.PhoneNum,
		Gender:       getData.Gender,
		VaccineCount: getData.VaccineCount,
		BirthDate:    getData.BirthDate,
		Age:          ageUser.Age,
	}

	return responseUser, nil
}

func (s *userService) GetUserHistory(nik string) (response.UserHistory, error) {
	var historyUser response.UserHistory

	getData, err := s.UserRepo.GetUserHistoryByNik(nik)
	if err != nil {
		return historyUser, err
	}

	getDataUser, err := s.UserRepo.GetUserDataByNikNoAddress(nik)
	if err != nil {
		return historyUser, err
	}

	ageUser, err := s.UserRepo.GetAgeUser(getDataUser)
	if err != nil {
		return historyUser, err
	}

	countHistoryUser, err := s.HistoryRepo.GetHistoriesByNIK(nik)
	if err != nil {
		return historyUser, err
	}

	historyList := make([]response.HistoryCustomUser, len(countHistoryUser))

	for i, val := range countHistoryUser {
		dataBooking, err := s.BookingRepo.GetBooking(val.IdBooking)
		if err != nil {
			return historyUser, err
		}

		GetHealthFacil, err := s.HealthRepo.GetHealthFacilitiesById(dataBooking.Session.Vaccine.IdHealthFacilities)
		if err != nil {
			return historyUser, err
		}

		dataHealthFacilities := response.HealthFacilitiesCustomUser{
			ID:        GetHealthFacil.ID,
			Email:     GetHealthFacil.Email,
			PhoneNum:  GetHealthFacil.PhoneNum,
			Name:      GetHealthFacil.Name,
			Image:     GetHealthFacil.Image,
			CreatedAt: GetHealthFacil.CreatedAt,
			UpdatedAt: GetHealthFacil.UpdatedAt,
			Address:   GetHealthFacil.Address,
		}

		bookingLoop := response.BookingHistoryLoop{
			ID:               dataBooking.ID,
			IdSession:        dataBooking.IdSession,
			NikUser:          dataBooking.NikUser,
			Queue:            &dataBooking.Queue,
			Status:           dataBooking.Status,
			CreatedAt:        dataBooking.CreatedAt,
			UpdatedAt:        dataBooking.UpdatedAt,
			Session:          *dataBooking.Session,
			HealthFacilities: dataHealthFacilities,
		}

		historyList[i] = response.HistoryCustomUser{
			ID:         val.ID,
			IdBooking:  val.IdBooking,
			NikUser:    val.NikUser,
			IdSameBook: val.IdSameBook,
			Status:     val.Status,
			CreatedAt:  val.CreatedAt,
			UpdatedAt:  val.UpdatedAt,
			Booking:    bookingLoop,
		}
	}

	historyUser = response.UserHistory{
		NIK:          getData.NIK,
		Email:        getData.Email,
		FullName:     getData.FullName,
		PhoneNum:     getData.PhoneNum,
		Gender:       getData.Gender,
		VaccineCount: getData.VaccineCount,
		BirthDate:    getData.BirthDate,
		Age:          ageUser.Age,
		Address:      getData.Address,
		History:      historyList,
	}

	return historyUser, nil
}

func (s *userService) GetUserRegisteredDashboard() (response.RegisterStatistic, error) {
	var responseDash response.RegisterStatistic
	RegisteredData := make([]response.DashboardForm, 3)

	var Name string
	var FirstDose int
	var SecondDose int
	var ThirdDose int
	var Kosong int

	getData, err := s.UserRepo.GetAllUser()
	if err != nil {
		return responseDash, err
	}

	for _, val := range getData {
		ageUser, err := s.UserRepo.GetAgeUser(val)
		if err != nil {
			return responseDash, err
		}
		RegisteredData[0].Name = "12 - 17 Tahun"
		RegisteredData[1].Name = "18 - 59 Tahun"
		RegisteredData[2].Name = "60 Tahun Ke atas"
		if ageUser.Age >= 12 && ageUser.Age <= 17 {
			if val.VaccineCount == 1 {
				FirstDose += 1
			} else if val.VaccineCount == 2 {
				SecondDose += 1
			} else if val.VaccineCount == 3 {
				ThirdDose += 1
			} else {
				Kosong = 0
				fmt.Print(Kosong)
			}
			Name = "12 - 17 Tahun"
			RegisteredData[0] = response.DashboardForm{
				Name:      Name,
				DoseOne:   FirstDose,
				DoseTwo:   SecondDose,
				DoseThree: ThirdDose,
			}
		} else if ageUser.Age >= 18 && ageUser.Age <= 59 {
			if val.VaccineCount == 1 {
				FirstDose += 1
			} else if val.VaccineCount == 2 {
				SecondDose += 1
			} else if val.VaccineCount == 3 {
				ThirdDose += 1
			} else {
				Kosong = 0
				fmt.Print(Kosong)
			}
			Name = "18 - 59 Tahun"
			RegisteredData[1] = response.DashboardForm{
				Name:      Name,
				DoseOne:   FirstDose,
				DoseTwo:   SecondDose,
				DoseThree: ThirdDose,
			}
		} else {
			if val.VaccineCount == 1 {
				FirstDose += 1
			} else if val.VaccineCount == 2 {
				SecondDose += 1
			} else if val.VaccineCount == 3 {
				ThirdDose += 1
			} else {
				Kosong = 0
				fmt.Print(Kosong)
			}
			Name = "60 Tahun Ke atas"
			RegisteredData[2] = response.DashboardForm{
				Name:      Name,
				DoseOne:   FirstDose,
				DoseTwo:   SecondDose,
				DoseThree: ThirdDose,
			}
		}
	}
	responseData := response.RegisterStatistic{
		RegisteredStat: RegisteredData,
	}

	return responseData, nil
}

func (s *userService) UpdateUserProfile(payloads payload.UpdateUser, nik string) (response.UpdateUser, error) {
	var dataResp response.UpdateUser

	if payloads.Gender != "P" && payloads.Gender != "L" {
		return dataResp, errors.New("input gender must P or L")
	}

	dateBirth, err := time.Parse("2006-01-02", payloads.BirthDate)
	if err != nil {
		return dataResp, err
	}

	hashPass, err := util.HashPassword(payloads.Password)
	if err != nil {
		return dataResp, err
	}

	dataUser := model.User{
		Email:     payloads.Email,
		Password:  hashPass,
		FullName:  payloads.FullName,
		PhoneNum:  payloads.PhoneNum,
		Gender:    payloads.Gender,
		BirthDate: dateBirth,
	}

	if err := s.UserRepo.UpdateUserProfile(dataUser, nik); err != nil {
		return dataResp, err
	}

	data, err := s.GetUserDataByNikNoAddress(nik)
	if err != nil {
		return dataResp, err
	}

	dataResp = response.UpdateUser{
		FullName:  data.FullName,
		NikUser:   data.NIK,
		Email:     data.Email,
		PhoneNum:  data.PhoneNum,
		Gender:    data.Gender,
		BirthDate: dateBirth,
	}

	return dataResp, nil
}

func (s *userService) DeleteUserProfile(nik string) error {

	if err := s.AddressRepo.DeleteAddressUser(nik); err != nil {
		return err
	}

	if err := s.UserRepo.DeleteUser(nik); err != nil {
		return err
	}

	return nil
}

func (s *userService) NearbyHealthFacilities(payloads payload.NearbyHealth, nik string) (response.UserNearbyHealth, error) {
	var result response.UserNearbyHealth
	var tempData []response.HealthResponse
	var tempRes []response.HealthResponse

	userProfile, err := s.UserRepo.GetUserDataByNik(nik)
	if err != nil {
		return result, err
	}

	allHealthFacilities, err := s.HealthRepo.GetAllHealthFacilities()
	tempData = make([]response.HealthResponse, len(allHealthFacilities))
	if err != nil {
		return result, err
	}

	for i, val := range allHealthFacilities {
		newRanges := util.FindRange(
			payloads.Latitude,
			payloads.Longitude,
			val.Address.Latitude,
			val.Address.Longitude)
		if newRanges < 10 {
			tempData[i] = response.HealthResponse{
				ID:       val.ID,
				Email:    val.Email,
				PhoneNum: val.PhoneNum,
				Name:     val.Name,
				Image:    val.Image,
				Ranges:   newRanges,
				Address:  *val.Address,
				Vaccine:  val.Vaccine,
			}
		}
	}

	sort.Slice(tempData, func(i, j int) bool {
		return tempData[i].Ranges < tempData[j].Ranges
	})

	length := 0
	for _, val := range tempData {
		if val.ID == "" {
			length += 1
		}
	}
	tempRes = append(tempRes, tempData[length:]...)

	ageUser, err := s.UserRepo.GetAgeUser(userProfile)
	if err != nil {
		return result, err
	}

	result = response.UserNearbyHealth{
		User: response.UserProfile{
			NIK:          userProfile.NIK,
			Email:        userProfile.Email,
			FullName:     userProfile.FullName,
			PhoneNum:     userProfile.PhoneNum,
			Gender:       userProfile.Gender,
			VaccineCount: userProfile.VaccineCount,
			Age:          ageUser.Age,
			Address:      userProfile.Address,
		},
		HealthFacilities: tempRes,
	}

	return result, nil
}
