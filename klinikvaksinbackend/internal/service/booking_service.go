package service

import (
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/dto/payload"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/dto/response"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/model"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/repository"
)

type BookingService interface {
	CreateBooking(payloads []payload.BookingPayload) ([]response.BookingResponseCustom, error)
	GetAllBooking() ([]response.BookingResponse, error)
	GetBookingBysSession(id string) ([]response.BookingResponse, error)
	GetBookingDashboard() (response.Dashboard, error)
	GetBooking(id string) (response.BookingResponse, error)
	UpdateAccAttended(payloads []payload.UpdateAccHistory) ([]response.HistoryResponse, error)
	UpdateBooking(payloads []payload.BookingUpdate) ([]response.BookingResponseCustom, error)
	UpdateCancelBooking(payloads payload.BookingCancel, nik string) (response.BookingResponseCustom, error)
	DeleteBooking(id string) error
}

type bookingService struct {
	BookingRepo repository.BookingRepository
	HistoryRepo repository.HistoriesRepository
	SessionRepo repository.SessionRepository
	UserRepo    repository.UserRepository
}

func NewBookingService(
	bookingRepo repository.BookingRepository,
	historyRepo repository.HistoriesRepository,
	sessionRepo repository.SessionRepository,
	userRepo repository.UserRepository) *bookingService {
	return &bookingService{
		BookingRepo: bookingRepo,
		HistoryRepo: historyRepo,
		SessionRepo: sessionRepo,
		UserRepo:    userRepo,
	}
}

func (s *bookingService) CreateBooking(payloads []payload.BookingPayload) ([]response.BookingResponseCustom, error) {
	historyData := make([]model.VaccineHistory, len(payloads))
	bookingModel := make([]model.BookingSession, len(payloads))
	resBooking := make([]response.BookingResponseCustom, len(payloads))

	idSameBooked := uuid.NewString()
	createdData := time.Now()
	updatedData := time.Now()
	idBooking := ""
	statusData := "OnProcess"

	for i, val := range payloads {
		defValue := 0
		idBooking = uuid.NewString()
		defId := idBooking

		_, err := s.HistoryRepo.GetHistoryByNIK(defId, val.NikUser)
		if err == nil {
			return resBooking, errors.New("already booked")
		}

		bookingModel[i] = model.BookingSession{
			ID:        idBooking,
			IdSession: val.IdSession,
			NikUser:   val.NikUser,
			Queue:     defValue,
			Status:    &statusData,
			CreatedAt: createdData,
			UpdatedAt: updatedData,
		}

		historyData[i] = model.VaccineHistory{
			ID:         uuid.NewString(),
			IdBooking:  defId,
			NikUser:    val.NikUser,
			IdSameBook: idSameBooked,
			Status:     &statusData,
			CreatedAt:  createdData,
			UpdatedAt:  updatedData,
		}
		err = s.BookingRepo.CreateBooking(bookingModel[i])
		if err != nil {
			return resBooking, err
		}
	}

	for _, v := range historyData {
		err := s.HistoryRepo.CreateHistory(v)
		if err != nil {
			return resBooking, err
		}
	}

	getSession, err := s.SessionRepo.GetSessionById(payloads[0].IdSession)
	if err != nil {
		return resBooking, err
	}

	getBookedByIdSession, err := s.BookingRepo.GetBookingBySession(payloads[0].IdSession)
	if err != nil {
		return resBooking, err
	}

	countBook := getSession.Capacity - len(getBookedByIdSession)

	for i, val := range bookingModel {
		getSessionId, err := s.SessionRepo.GetSessionById(val.IdSession)
		if err != nil {
			return resBooking, err
		}

		idSameBook, err := s.HistoryRepo.GetHistoryByNIK(val.ID, val.NikUser)
		if err != nil {
			return resBooking, err
		}

		sessionData := response.BookingSessionCustom{
			ID:           getSessionId.ID,
			IdVaccine:    getSessionId.IdVaccine,
			SessionName:  getSessionId.SessionName,
			CapacityLeft: countBook,
			Capacity:     getSession.Capacity,
			Dose:         getSessionId.Dose,
			Date:         getSessionId.Date,
			IsClose:      getSession.IsClose,
			StartSession: getSessionId.StartSession,
			EndSession:   getSessionId.EndSession,
			CreatedAt:    getSessionId.CreatedAt,
			UpdatedAt:    getSessionId.UpdatedAt,
			Vaccine:      getSession.Vaccine,
		}

		historyData := response.BookingHistoryCustom{
			ID:         idSameBook.ID,
			IdBooking:  idSameBook.IdBooking,
			NikUser:    idSameBook.NikUser,
			IdSameBook: idSameBook.IdSameBook,
			Status:     idSameBook.Status,
			CreatedAt:  idSameBook.CreatedAt,
			UpdatedAt:  idSameBook.UpdatedAt,
			User:       idSameBook.User,
		}

		resBooking[i] = response.BookingResponseCustom{
			ID:        val.ID,
			IdSession: val.IdSession,
			NikUser:   val.NikUser,
			Queue:     &val.Queue,
			Status:    val.Status,
			CreatedAt: val.CreatedAt,
			UpdatedAt: val.UpdatedAt,
			Session:   sessionData,
			History:   historyData,
		}
	}

	return resBooking, nil
}

func (s *bookingService) UpdateBooking(payloads []payload.BookingUpdate) ([]response.BookingResponseCustom, error) {
	var data []response.BookingResponseCustom
	var bookingData []model.BookingSession

	data = make([]response.BookingResponseCustom, len(payloads))
	bookingData = make([]model.BookingSession, len(payloads))
	newRes := make([]response.BookingResponseCustom, len(payloads))
	newResReject := make([]response.BookingResponseCustom, len(payloads))

	var newQueue int
	var initQueu int = 0
	var getbackCap int

	if payloads[0].Status == "Rejected" {
		for i, v := range payloads {

			getSession, err := s.SessionRepo.GetSessionById(v.IdSession)
			if err != nil {
				return data, err
			}

			if v.Status != "Accepted" && v.Status != "Rejected" {
				return data, errors.New("input status must Accepted or Rejected")
			}
			bookingData[i] = model.BookingSession{
				ID:        v.ID,
				IdSession: v.IdSession,
				NikUser:   v.NikUser,
				Status:    &v.Status,
			}

			updateData, err := s.BookingRepo.UpdateBookingAcc(bookingData[i])
			if err != nil {
				return data, err
			}

			statusHistory := "Absent"

			dataHistoryUpdate := model.VaccineHistory{
				Status: &statusHistory,
			}

			idSameBook, err := s.HistoryRepo.GetHistoryByNIK(v.ID, v.NikUser)
			if err != nil {
				return data, err
			}

			getBookedByIdSession, err := s.BookingRepo.GetBookingBySessionDen(v.IdSession)
			if err != nil {
				return data, err
			}
			getbackCap = getSession.Capacity - len(getBookedByIdSession)

			_, err = s.HistoryRepo.UpdateHistoryByNik(dataHistoryUpdate, v.NikUser, v.ID)
			if err != nil {
				return data, err
			}

			sessionData := response.BookingSessionCustom{
				ID:           getSession.ID,
				IdVaccine:    getSession.IdVaccine,
				SessionName:  getSession.SessionName,
				CapacityLeft: getbackCap,
				Capacity:     getSession.Capacity,
				Dose:         getSession.Dose,
				Date:         getSession.Date,
				IsClose:      getSession.IsClose,
				StartSession: getSession.StartSession,
				EndSession:   getSession.EndSession,
				CreatedAt:    getSession.CreatedAt,
				UpdatedAt:    getSession.UpdatedAt,
				Vaccine:      getSession.Vaccine,
			}

			historyData := response.BookingHistoryCustom{
				ID:         idSameBook.ID,
				IdBooking:  idSameBook.IdBooking,
				NikUser:    idSameBook.NikUser,
				IdSameBook: idSameBook.IdSameBook,
				Status:     idSameBook.Status,
				CreatedAt:  idSameBook.CreatedAt,
				UpdatedAt:  idSameBook.UpdatedAt,
				User:       idSameBook.User,
			}

			newResReject[i] = response.BookingResponseCustom{
				ID:        updateData.ID,
				IdSession: updateData.IdSession,
				NikUser:   updateData.NikUser,
				Queue:     &updateData.Queue,
				Status:    updateData.Status,
				CreatedAt: updateData.CreatedAt,
				UpdatedAt: updateData.UpdatedAt,
				Session:   sessionData,
				History:   historyData,
			}
		}

		return newResReject, nil
	}

	for i, v := range payloads {

		getSession, err := s.SessionRepo.GetSessionById(v.IdSession)
		if err != nil {
			return data, err
		}

		if v.Status != "Accepted" && v.Status != "Rejected" {
			return data, errors.New("input status must Accepted or Rejected")
		}

		checkStatus, err := s.BookingRepo.GetBooking(v.ID)
		if err != nil {
			return data, err
		}

		if *checkStatus.Status == "Accepted" {
			return data, errors.New("you already accept users")
		}

		lastQueue, err := s.BookingRepo.FindMaxQueue(v.IdSession)
		if err != nil {
			return data, err
		}
		newQueue = lastQueue.Queue

		if newQueue != 0 {
			initQueu = newQueue + 1
		} else {
			initQueu += 1
		}

		bookingData[i] = model.BookingSession{
			ID:        v.ID,
			IdSession: v.IdSession,
			NikUser:   v.NikUser,
			Queue:     initQueu,
			Status:    &v.Status,
		}
		initQueu += 1

		updateData, err := s.BookingRepo.UpdateBookingAcc(bookingData[i])
		if err != nil {
			return data, err
		}

		idSameBook, err := s.HistoryRepo.GetHistoryByNIK(v.ID, v.NikUser)
		if err != nil {
			return data, err
		}

		getBookedByIdSession, err := s.BookingRepo.GetBookingBySessionDen(v.IdSession)
		if err != nil {
			return data, err
		}

		getbackCap = getSession.Capacity - len(getBookedByIdSession)

		sessionData := response.BookingSessionCustom{
			ID:           getSession.ID,
			IdVaccine:    getSession.IdVaccine,
			SessionName:  getSession.SessionName,
			CapacityLeft: getbackCap,
			Capacity:     getSession.Capacity,
			Dose:         getSession.Dose,
			Date:         getSession.Date,
			IsClose:      getSession.IsClose,
			StartSession: getSession.StartSession,
			EndSession:   getSession.EndSession,
			CreatedAt:    getSession.CreatedAt,
			UpdatedAt:    getSession.UpdatedAt,
			Vaccine:      getSession.Vaccine,
		}

		historyData := response.BookingHistoryCustom{
			ID:         idSameBook.ID,
			IdBooking:  idSameBook.IdBooking,
			NikUser:    idSameBook.NikUser,
			IdSameBook: idSameBook.IdSameBook,
			Status:     idSameBook.Status,
			CreatedAt:  idSameBook.CreatedAt,
			UpdatedAt:  idSameBook.UpdatedAt,
			User:       idSameBook.User,
		}

		newRes[i] = response.BookingResponseCustom{
			ID:        updateData.ID,
			IdSession: updateData.IdSession,
			NikUser:   updateData.NikUser,
			Queue:     &updateData.Queue,
			Status:    updateData.Status,
			CreatedAt: updateData.CreatedAt,
			UpdatedAt: updateData.UpdatedAt,
			Session:   sessionData,
			History:   historyData,
		}
	}
	return newRes, nil
}

func (s *bookingService) UpdateAccAttended(payloads []payload.UpdateAccHistory) ([]response.HistoryResponse, error) {
	updateData := make([]response.HistoryResponse, len(payloads))

	var defaultVaccineCount int

	for i, val := range payloads {
		if val.Status != "Attended" && val.Status != "Absent" {
			return updateData, errors.New("input status must Attended or Absent")
		}

		updateModel := model.VaccineHistory{
			ID:     val.ID,
			Status: &val.Status,
		}

		_, err := s.HistoryRepo.UpdateHistory(updateModel, val.ID)
		if err != nil {
			return updateData, err
		}

		dataNik, err := s.HistoryRepo.CheckVaccineCount(val.NikUser)
		if err != nil {
			return updateData, err
		}

		defaultVaccineCount = len(dataNik)

		updateUserCount := model.User{
			NIK:          val.NikUser,
			VaccineCount: defaultVaccineCount,
		}

		if err := s.UserRepo.UpdateAccUserProfile(updateUserCount); err != nil {
			return updateData, err
		}

		dataHistory, err := s.HistoryRepo.GetHistoryByIdNoUserHistory(val.ID)
		if err != nil {
			return updateData, err
		}

		updateData[i] = response.HistoryResponse{
			ID:         dataHistory.ID,
			IdBooking:  dataHistory.IdBooking,
			NikUser:    dataHistory.NikUser,
			IdSameBook: dataHistory.IdBooking,
			Status:     dataHistory.Status,
			CreatedAt:  dataHistory.CreatedAt,
			UpdatedAt:  dataHistory.UpdatedAt,
			User:       *dataHistory.User,
		}
	}
	return updateData, nil
}

func (s *bookingService) UpdateCancelBooking(payloads payload.BookingCancel, nik string) (response.BookingResponseCustom, error) {
	var responseData response.BookingResponseCustom

	statusBooking := "Rejected"
	statusHistory := "Absent"

	updateModelBooking := model.BookingSession{
		ID:        payloads.ID,
		IdSession: payloads.IdSession,
		NikUser:   nik,
		Status:    &statusBooking,
	}

	err := s.BookingRepo.UpdateBooking(updateModelBooking)
	if err != nil {
		return responseData, err
	}

	updateModelHistory := model.VaccineHistory{
		Status: &statusHistory,
	}

	_, err = s.HistoryRepo.UpdateHistoryByNik(updateModelHistory, nik, payloads.ID)
	if err != nil {
		return responseData, err
	}

	dataBooking, err := s.BookingRepo.GetBooking(payloads.ID)
	if err != nil {
		return responseData, err
	}

	dataSession, err := s.SessionRepo.GetSessionById(payloads.IdSession)
	if err != nil {
		return responseData, err
	}

	countHistory, err := s.HistoryRepo.GetHistoryByNIK(payloads.ID, nik)
	if err != nil {
		return responseData, err
	}

	getSession, err := s.SessionRepo.GetSessionById(payloads.IdSession)
	if err != nil {
		return responseData, err
	}

	getBookedByIdSession, err := s.BookingRepo.GetBookingBySessionDen(payloads.IdSession)
	if err != nil {
		return responseData, err
	}
	getbackCap := getSession.Capacity - len(getBookedByIdSession)

	sessionData := response.BookingSessionCustom{
		ID:           dataSession.ID,
		IdVaccine:    dataSession.IdVaccine,
		SessionName:  dataSession.SessionName,
		Capacity:     dataSession.Capacity,
		CapacityLeft: getbackCap,
		Dose:         dataSession.Dose,
		Date:         dataSession.Date,
		IsClose:      dataSession.IsClose,
		StartSession: dataSession.StartSession,
		EndSession:   dataSession.EndSession,
		CreatedAt:    dataSession.CreatedAt,
		UpdatedAt:    dataSession.UpdatedAt,
		Vaccine:      dataSession.Vaccine,
	}

	historyData := response.BookingHistoryCustom{
		ID:         countHistory.ID,
		IdBooking:  countHistory.IdBooking,
		NikUser:    countHistory.NikUser,
		IdSameBook: countHistory.IdSameBook,
		Status:     countHistory.Status,
		CreatedAt:  countHistory.CreatedAt,
		UpdatedAt:  countHistory.UpdatedAt,
		User:       countHistory.User,
	}

	responseData = response.BookingResponseCustom{
		ID:        dataBooking.ID,
		IdSession: dataBooking.IdSession,
		Queue:     &dataBooking.Queue,
		Status:    dataBooking.Status,
		CreatedAt: dataBooking.CreatedAt,
		UpdatedAt: dataBooking.UpdatedAt,
		Session:   sessionData,
		History:   historyData,
	}
	return responseData, nil
}

func (s *bookingService) GetAllBooking() ([]response.BookingResponse, error) {
	var bookingResponse []response.BookingResponse

	getBooking, err := s.BookingRepo.GetAllBooking()

	if err != nil {
		return bookingResponse, err
	}

	bookingResponse = make([]response.BookingResponse, len(getBooking))

	for i, v := range getBooking {
		bookingResponse[i] = response.BookingResponse{
			ID:        v.ID,
			IdSession: v.IdSession,
			Queue:     &v.Queue,
			Status:    v.Status,
			CreatedAt: v.CreatedAt,
			UpdatedAt: v.UpdatedAt,
			Session:   *v.Session,
			History:   v.History,
		}
	}

	return bookingResponse, nil
}

func (s *bookingService) GetBookingBysSession(id string) ([]response.BookingResponse, error) {
	var responseBooking []response.BookingResponse

	getData, err := s.BookingRepo.GetBookingBySession(id)
	if err != nil {
		return responseBooking, err
	}

	responseBooking = make([]response.BookingResponse, len(getData))

	for i, val := range getData {
		responseBooking[i] = response.BookingResponse{
			ID:        val.ID,
			IdSession: val.IdSession,
			Queue:     &val.Queue,
			Status:    val.Status,
			CreatedAt: val.CreatedAt,
			UpdatedAt: val.UpdatedAt,
		}
	}

	return responseBooking, nil
}

func (s *bookingService) GetBooking(id string) (response.BookingResponse, error) {
	var responseBooking response.BookingResponse

	getData, err := s.BookingRepo.GetBooking(id)
	if err != nil {
		return responseBooking, err
	}

	responseBooking = response.BookingResponse{
		ID:        getData.ID,
		IdSession: getData.IdSession,
		Queue:     &getData.Queue,
		Status:    getData.Status,
		CreatedAt: getData.CreatedAt,
		UpdatedAt: getData.UpdatedAt,
	}

	return responseBooking, nil
}

func (s *bookingService) DeleteBooking(id string) error {
	if err := s.BookingRepo.DeleteBooking(id); err != nil {
		return err
	}

	return nil
}

func (s *bookingService) GetBookingDashboard() (response.Dashboard, error) {
	var bookingResponse response.Dashboard

	getBooking, err := s.BookingRepo.GetAllBooking()

	if err != nil {
		return bookingResponse, err
	}

	count := len(getBooking)

	bookingResponse = response.Dashboard{Booking: count}

	return bookingResponse, nil
}
