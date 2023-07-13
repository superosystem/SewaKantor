package controller

import (
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/dto/payload"
	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/service"
)

type BookingsController struct {
	BookingService service.BookingService
}

func NewBookingController(bookingServ service.BookingService) *BookingsController {
	return &BookingsController{
		BookingService: bookingServ,
	}
}

func (b *BookingsController) GetAllBookings(ctx echo.Context) error {
	allData, err := b.BookingService.GetAllBooking()
	if err != nil {
		return ctx.JSON(http.StatusInternalServerError, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	return ctx.JSON(http.StatusOK, map[string]interface{}{
		"error":    false,
		"messages": "success get all data booking",
		"data":     allData,
	})
}

func (b *BookingsController) GetBooking(ctx echo.Context) error {
	id := ctx.Param("id")

	data, err := b.BookingService.GetBooking(id)
	if err != nil {
		return ctx.JSON(http.StatusInternalServerError, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	return ctx.JSON(http.StatusOK, map[string]interface{}{
		"error":    false,
		"messages": "success get data booking",
		"data":     data,
	})
}

func (b *BookingsController) CreateBooking(ctx echo.Context) error {
	var payloads []payload.BookingPayload

	if err := ctx.Bind(&payloads); err != nil {
		return ctx.JSON(http.StatusBadRequest, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	data, err := b.BookingService.CreateBooking(payloads)
	if err != nil {
		return ctx.JSON(http.StatusBadRequest, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	return ctx.JSON(http.StatusCreated, map[string]interface{}{
		"error":    false,
		"messages": "success create data booking",
		"data":     data,
	})
}

func (b *BookingsController) UpdateBooking(ctx echo.Context) error {
	var payloads []payload.BookingUpdate

	if err := ctx.Bind(&payloads); err != nil {
		return ctx.JSON(http.StatusBadRequest, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	data, err := b.BookingService.UpdateBooking(payloads)
	if err != nil {
		return ctx.JSON(http.StatusBadRequest, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	return ctx.JSON(http.StatusOK, map[string]interface{}{
		"error":    false,
		"messages": "success update data booking",
		"data":     data,
	})
}

func (b *BookingsController) UpdateCanceledBooking(ctx echo.Context) error {
	var payloads payload.BookingCancel

	nik := ctx.Param("nik")

	if err := ctx.Bind(&payloads); err != nil {
		return ctx.JSON(http.StatusBadRequest, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	data, err := b.BookingService.UpdateCancelBooking(payloads, nik)
	if err != nil {
		return ctx.JSON(http.StatusBadRequest, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	return ctx.JSON(http.StatusOK, map[string]interface{}{
		"error":    false,
		"messages": "success update data booking",
		"data":     data,
	})
}

func (b *BookingsController) UpdateAccAttendend(ctx echo.Context) error {
	var payloads []payload.UpdateAccHistory

	if err := ctx.Bind(&payloads); err != nil {
		return ctx.JSON(http.StatusBadRequest, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	data, err := b.BookingService.UpdateAccAttended(payloads)
	if err != nil {
		return ctx.JSON(http.StatusBadRequest, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	return ctx.JSON(http.StatusOK, map[string]interface{}{
		"error":    false,
		"messages": "success update data history users",
		"data":     data,
	})
}

func (b *BookingsController) DeleteBooking(ctx echo.Context) error {
	id := ctx.Param("id")

	if err := b.BookingService.DeleteBooking(id); err != nil {
		return ctx.JSON(http.StatusInternalServerError, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	return ctx.JSON(http.StatusOK, map[string]interface{}{
		"error":   false,
		"message": "success delete booking",
	})
}

func (b *BookingsController) GetBookingDashboard(ctx echo.Context) error {
	allData, err := b.BookingService.GetBookingDashboard()
	if err != nil {
		return ctx.JSON(http.StatusInternalServerError, map[string]interface{}{
			"error":   true,
			"message": err.Error(),
		})
	}

	return ctx.JSON(http.StatusOK, map[string]interface{}{
		"error":    false,
		"messages": "success get all data booking",
		"data":     allData,
	})
}
