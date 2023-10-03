package offices

import (
	"fmt"
	"github.com/labstack/echo/v4"
	"github.com/superosystem/SewaKantor/backend/src/applications/middlewares"
	"github.com/superosystem/SewaKantor/backend/src/commons"
	"github.com/superosystem/SewaKantor/backend/src/domains/offices"
	"github.com/superosystem/SewaKantor/backend/src/infrastructures/storage"
	ctrl "github.com/superosystem/SewaKantor/backend/src/interfaces/http/api"
	"github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/offices/request"
	"github.com/superosystem/SewaKantor/backend/src/interfaces/http/api/offices/response"
	"strconv"

	"net/http"

	"github.com/golang-jwt/jwt"
)

type OfficeController struct {
	officeUsecase offices.Usecase
	cloudStorage  storage.CloudinaryConfiguration
}

func NewOfficeController(officeUC offices.Usecase, cs storage.CloudinaryConfiguration) *OfficeController {
	return &OfficeController{
		officeUsecase: officeUC,
		cloudStorage:  cs,
	}
}

func (oc *OfficeController) GetAll(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	officesData := oc.officeUsecase.GetAll()

	offices := []response.Office{}

	for _, office := range officesData {
		offices = append(offices, response.FromDomain(office))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "all offices", offices)
}

func (oc *OfficeController) GetByID(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	var id string = c.Param("office_id")

	office := oc.officeUsecase.GetByID(id)

	if office.ID == 0 {
		return ctrl.NewResponse(c, http.StatusNotFound, "failed", "office not found", "")
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "office found", response.FromDomain(office))
}

func (oc *OfficeController) Create(c echo.Context) error {
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

	var imageURLs []string

	input := request.Office{}

	if err := c.Bind(&input); err != nil {
		return ctrl.NewResponse(c, http.StatusBadRequest, "failed", "bind failed", "")
	}

	hourDTO := request.HourDTO{}

	if err := c.Bind(&hourDTO); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "bind failed")
	}

	// input hour validation
	if err := hourDTO.Validate(); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", fmt.Sprintf("%s", err))
	}

	facilityIdDTO := request.FacilitiesIdDTO{}

	if err := c.Bind(&facilityIdDTO); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "bind failed")
	}

	facilityIdList := commons.StringToList(facilityIdDTO.Id)

	// facilities_id list validation
	if err := commons.IsIdListStringAllowed(facilityIdDTO.Id); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", fmt.Sprintf("%s", err))
	}

	// multipart form
	form, err := c.MultipartForm()

	if err != nil {
		return ctrl.NewInfoResponse(c, http.StatusInternalServerError, "failed", "error when reading files")
	}

	files := form.File["images"]

	isfilesAllowed, filesCheckMsg := commons.IsFilesAllowed(files)

	if !isfilesAllowed {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", filesCheckMsg)
	}

	imageURLs, err = oc.cloudStorage.CloudinaryUploadOfficeImgs(files)

	if err != nil {
		return ctrl.NewInfoResponse(c, http.StatusConflict, "failed", "conflict when upload file in cloud image")
	}

	openHour, closeHour := commons.ConvertShiftClockToShiftTime(hourDTO.OpenHour, hourDTO.CloseHour)

	input.Images = imageURLs
	input.OpenHour = openHour
	input.CloseHour = closeHour
	input.FacilitiesId = facilityIdList

	err = input.Validate()

	if err != nil {
		return ctrl.NewResponse(c, http.StatusBadRequest, "failed", "validation failed", "")
	}

	office := oc.officeUsecase.Create(input.ToDomain())

	if office.ID == 0 {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "error when creating office, facilities ID did not exist")
	}

	getOffice := oc.officeUsecase.GetByID(strconv.Itoa(int(office.ID)))

	return ctrl.NewResponse(c, http.StatusCreated, "success", "office created", response.FromDomain(getOffice))
}

func (oc *OfficeController) Update(c echo.Context) error {
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

	var officeId string = c.Param("office_id")
	var imageURLs []string

	checkOfficeExisted := oc.officeUsecase.GetByID(officeId)

	if checkOfficeExisted.ID == 0 {
		return ctrl.NewInfoResponse(c, http.StatusNotFound, "failed", "office not found")
	}

	input := request.Office{}

	if err := c.Bind(&input); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "bind failed")
	}

	hourDTO := request.HourDTO{}

	if err := c.Bind(&hourDTO); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "bind failed")
	}

	// input hour validation
	if err := hourDTO.Validate(); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", fmt.Sprintf("%s", err))
	}

	facilityIdDTO := request.FacilitiesIdDTO{}

	if err := c.Bind(&facilityIdDTO); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "bind failed")
	}

	facilityIdList := commons.StringToList(facilityIdDTO.Id)

	// facilities_id list validation
	if err := commons.IsIdListStringAllowed(facilityIdDTO.Id); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", fmt.Sprintf("wrong input in facilities_id, %s", err))
	}

	// multipart form
	form, err := c.MultipartForm()

	if err != nil {
		return ctrl.NewInfoResponse(c, http.StatusInternalServerError, "failed", "error when reading files")
	}

	files := form.File["images"]

	if len(files) > 0 {
		isfilesAllowed, filesCheckMsg := commons.IsFilesAllowed(files)

		if !isfilesAllowed {
			return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", filesCheckMsg)
		}

		imageURLs, err = oc.cloudStorage.CloudinaryUploadOfficeImgs(files)

		if err != nil {
			return ctrl.NewInfoResponse(c, http.StatusConflict, "failed", "conflict when upload file in cloud image")
		}

		input.Images = imageURLs
	}

	openHour, closeHour := commons.ConvertShiftClockToShiftTime(hourDTO.OpenHour, hourDTO.CloseHour)
	input.OpenHour = openHour
	input.CloseHour = closeHour
	input.FacilitiesId = facilityIdList

	err = nil
	err = input.Validate()

	if err != nil {
		return ctrl.NewResponse(c, http.StatusBadRequest, "failed", "validation failed", err)
	}

	office := oc.officeUsecase.Update(officeId, input.ToDomain())

	if office.ID == 0 {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "error when updating office, facilities ID did not exist")
	}

	getOffice := oc.officeUsecase.GetByID(strconv.Itoa(int(office.ID)))

	return ctrl.NewResponse(c, http.StatusOK, "success", "office updated", response.FromDomain(getOffice))
}

func (oc *OfficeController) Delete(c echo.Context) error {
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

	var officeId string = c.Param("office_id")

	fmt.Println(officeId)

	isSuccess := oc.officeUsecase.Delete(officeId)

	if !isSuccess {
		return ctrl.NewResponse(c, http.StatusNotFound, "failed", "office not found", "")
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "office deleted", "")
}

func (oc *OfficeController) SearchByCity(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	var city string = c.Param("city")

	offices := []response.Office{}

	officesData := oc.officeUsecase.SearchByCity(city)

	for _, office := range officesData {
		offices = append(offices, response.FromDomain(office))
	}

	if len(offices) == 0 {
		return ctrl.NewInfoResponse(c, http.StatusNotFound, "failed", fmt.Sprintf("%s city not found", city))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "grouping by city", offices)
}

func (oc *OfficeController) SearchByRate(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	var rate string = c.Param("rate")

	offices := []response.Office{}

	officesData := oc.officeUsecase.SearchByRate(rate)

	for _, office := range officesData {
		offices = append(offices, response.FromDomain(office))
	}

	if len(offices) == 0 {
		return ctrl.NewInfoResponse(c, http.StatusNotFound, "failed", fmt.Sprintf("city with rate %s not found", rate))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "grouping by rate", offices)
}

func (oc *OfficeController) SearchByTitle(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	var title string = c.QueryParam("search")

	offices := oc.officeUsecase.SearchByTitle(title)

	if offices.ID == 0 {
		return ctrl.NewInfoResponse(c, http.StatusNotFound, "failed", fmt.Sprintf("city with title = %s not found", title))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "office found", offices)
}

func (oc *OfficeController) GetOffices(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	officesData := oc.officeUsecase.GetOffices()

	offices := []response.Office{}

	for _, office := range officesData {
		offices = append(offices, response.FromDomain(office))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "all offices type : offices", offices)
}

func (oc *OfficeController) GetCoworkingSpace(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	coworkingSpaceData := oc.officeUsecase.GetCoworkingSpace()

	coworkingSpaces := []response.Office{}

	for _, coworkingSpace := range coworkingSpaceData {
		coworkingSpaces = append(coworkingSpaces, response.FromDomain(coworkingSpace))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "all offices type : coworking space", coworkingSpaces)
}

func (oc *OfficeController) GetMeetingRooms(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	meetingRoomsData := oc.officeUsecase.GetMeetingRooms()

	meetingRooms := []response.Office{}

	for _, meetingRoom := range meetingRoomsData {
		meetingRooms = append(meetingRooms, response.FromDomain(meetingRoom))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "all offices type : meeting rooms", meetingRooms)
}

func (oc *OfficeController) GetRecommendation(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	recommendationsData := oc.officeUsecase.GetRecommendation()

	recommendations := []response.Office{}

	for _, recommendation := range recommendationsData {
		recommendations = append(recommendations, response.FromDomain(recommendation))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", "recommendation offices", recommendations)
}

func (oc *OfficeController) GetNearest(c echo.Context) error {
	token := c.Get("user").(*jwt.Token)

	isListed := middlewares.CheckToken(token.Raw)

	if !isListed {
		return ctrl.NewInfoResponse(c, http.StatusUnauthorized, "failed", "invalid token")
	}

	var err error
	var lat string = c.QueryParam("lat")
	var lng string = c.QueryParam("long")

	if err := commons.IsGeolocationStringInputAllowed(lat, lng); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", fmt.Sprintf("%s", err))
	}

	var geolocation = request.GeoLocationDTO{}

	if geolocation.Lat, err = strconv.ParseFloat(lat, 64); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "failed when parsing, input the latitude in float number")
	}

	if geolocation.Lng, err = strconv.ParseFloat(lng, 64); err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "failed when parsing, input the longitude in float number")
	}

	err = geolocation.Validate()

	if err != nil {
		return ctrl.NewInfoResponse(c, http.StatusBadRequest, "failed", "wrong geolocation format")
	}

	nearestsData := oc.officeUsecase.GetNearest(lat, lng)

	nearest := []response.Office{}

	for _, n := range nearestsData {
		nearest = append(nearest, response.FromDomain(n))
	}

	return ctrl.NewResponse(c, http.StatusOK, "success", fmt.Sprintf("all nearest place: %s,%s", lat, lng), nearest)
}
