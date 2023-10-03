package commons

import (
	"github.com/superosystem/SewaKantor/backend/src/applications/middlewares"

	"github.com/golang-jwt/jwt"
	"github.com/labstack/echo/v4"
)

func GetPayloadInfo(c echo.Context) *middlewares.JwtCustomClaims {
	token := c.Get("user").(*jwt.Token)
	payload := middlewares.GetPayload(token)

	return payload
}
