package api

import "github.com/labstack/echo/v4"

type Response[T any] struct {
	Status  string `json:"status"`
	Message string `json:"message"`
	Data    T      `json:"data"`
}

type InfoResponse struct {
	Status  string `json:"status"`
	Message string `json:"message"`
}

type ErrorResponse struct {
	Status  string `json:"status"`
	Message string `json:"message"`
	Error   string `json:"error"`
}

func NewResponse[T any](c echo.Context, statusCode int, statusMessage string, message string, data T) error {
	return c.JSON(statusCode, Response[T]{
		Status:  statusMessage,
		Message: message,
		Data:    data,
	})
}

func NewInfoResponse(c echo.Context, statusCode int, statusMessage string, message string) error {
	return c.JSON(statusCode, InfoResponse{
		Status:  statusMessage,
		Message: message,
	})
}

func NewErrorResponse(c echo.Context, statusCode int, statusMessage string, message string, err string) error {
	return c.JSON(statusCode, ErrorResponse{
		Status:  statusMessage,
		Message: message,
		Error:   err,
	})
}
