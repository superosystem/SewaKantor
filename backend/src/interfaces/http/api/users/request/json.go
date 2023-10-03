package request

import (
	validator "github.com/go-playground/validator/v10"
	"github.com/superosystem/SewaKantor/backend/src/domains/users"
)

type User struct {
	FullName             string `json:"full_name" validate:"required"`
	Gender               string `json:"gender" validate:"required,oneof=female male"`
	Email                string `json:"email" validate:"required,email,lowercase"`
	Password             string `json:"password" validate:"required"`
	ConfirmationPassword string `json:"confirmation_password" validate:"required"`
	Photo                string `json:"photo" form:"photo"`
	Roles                string `json:"roles"`
}

type UserLogin struct {
	Email    string `json:"email" validate:"required,email,lowercase"`
	Password string `json:"password" validate:"required"`
}

type UserPhoto struct {
	Photo string `json:"photo" form:"photo"`
}

func (req *User) ToDomainRegister() *users.Domain {
	return &users.Domain{
		FullName: req.FullName,
		Gender:   req.Gender,
		Email:    req.Email,
		Password: req.Password,
	}
}

func (req *UserLogin) ToDomainLogin() *users.LoginDomain {
	return &users.LoginDomain{
		Email:    req.Email,
		Password: req.Password,
	}
}

func (req *UserPhoto) ToDomainPhoto() *users.PhotoDomain {
	return &users.PhotoDomain{
		Photo: req.Photo,
	}
}

func (req *User) Validate() error {
	validate := validator.New()

	err := validate.Struct(req)

	return err
}

func (req *UserLogin) Validate() error {
	validate := validator.New()

	err := validate.Struct(req)

	return err
}
