package middlewares

import (
	"time"

	"github.com/golang-jwt/jwt"
	"github.com/labstack/echo/v4/middleware"
)

var tokenList = make([]string, 5)
var refreshTokenList = make([]string, 5)

type JwtCustomClaims struct {
	ID string `json:"id"`
	jwt.StandardClaims
	Roles string `json:"roles"`
}

type ConfigJWT struct {
	SecretJWT       string
	ExpiresDuration int
}

type TokenPair struct {
	AccessToken  string
	RefreshToken string
}

func (jwtConf *ConfigJWT) Init() middleware.JWTConfig {
	return middleware.JWTConfig{
		Claims:     &JwtCustomClaims{},
		SigningKey: []byte(jwtConf.SecretJWT),
	}
}

func (jwtConf *ConfigJWT) GenerateTokenPair(userID string, roles string) TokenPair {
	tokenClaims := JwtCustomClaims{
		userID,
		jwt.StandardClaims{
			ExpiresAt: time.Now().Local().Add(time.Hour * time.Duration(int64(jwtConf.ExpiresDuration))).Unix(),
		},
		roles,
	}

	//create token with claims
	t := jwt.NewWithClaims(jwt.SigningMethodHS256, tokenClaims)
	token, _ := t.SignedString([]byte(jwtConf.SecretJWT))
	tokenList = append(tokenList, token)

	rt := jwt.New(jwt.SigningMethodHS256)
	rtClaims := rt.Claims.(jwt.MapClaims)
	rtClaims["id"] = userID
	rtClaims["exp"] = time.Now().Local().Add(time.Hour * time.Duration(int64(jwtConf.ExpiresDuration)) * 24).Unix()

	refreshToken, _ := rt.SignedString([]byte(jwtConf.SecretJWT))
	refreshTokenList = append(refreshTokenList, refreshToken)

	response := TokenPair{}

	response.AccessToken = token
	response.RefreshToken = refreshToken

	return response
}

func CheckToken(token string) bool {
	for _, tkn := range tokenList {
		if tkn == token {
			return true
		}
	}

	return false
}

func CheckRefreshToken(refreshToken string) bool {
	for _, rt := range refreshTokenList {
		if rt == refreshToken {
			return true
		}
	}

	return false
}

func GetPayload(token *jwt.Token) *JwtCustomClaims {
	claims := token.Claims.(*JwtCustomClaims)

	return claims
}

func Logout(token string) bool {
	for i, tkn := range tokenList {
		if tkn == token {
			tokenList = append(tokenList[:i], tokenList[i+1:]...)
		}
	}

	for i, tkn := range refreshTokenList {
		if tkn == token {
			refreshTokenList = append(refreshTokenList[:i], refreshTokenList[i+1:]...)
		}
	}

	return true
}
