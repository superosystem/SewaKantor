package users

import (
	"fmt"
	"github.com/superosystem/SewaKantor/backend/src/domains/users"

	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

type userRepository struct {
	conn *gorm.DB
}

func NewMySQLRepository(conn *gorm.DB) users.Repository {
	return &userRepository{
		conn: conn,
	}
}

func (ur *userRepository) Register(userDomain *users.Domain) users.Domain {
	password, _ := bcrypt.GenerateFromPassword([]byte(userDomain.Password), bcrypt.DefaultCost)

	rec := FromDomain(userDomain)

	rec.Password = string(password)
	rec.Photo = ""
	rec.Roles = "user"

	var user User
	ur.conn.First(&user, "email = ?", userDomain.Email)

	// handle email if email already used for an account
	if user.ID != 0 {
		fmt.Println("user exist. proceed to login or use another email.")
		return users.Domain{}
	}

	result := ur.conn.Create(&rec)
	result.Last(&rec)

	return rec.ToDomain()
}

func (ur *userRepository) GetByEmail(userDomain *users.LoginDomain) users.Domain {
	var user User
	ur.conn.First(&user, "email = ?", userDomain.Email)

	if user.ID == 0 {
		fmt.Println("user not found")
		return users.Domain{}
	}

	err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(userDomain.Password))

	if err != nil {
		fmt.Println("password failed")
		return users.Domain{}
	}

	return user.ToDomain()
}

func (ur *userRepository) CheckUserByEmailOnly(id string, email string) bool {
	var user User

	ur.conn.Not("id = ? ", id).First(&user, "email = ?", email)

	if user.ID != 0 {
		return true
	}

	return false
}

func (ur *userRepository) GetAll() []users.Domain {
	var rec []User

	ur.conn.Find(&rec)

	var userDomain []users.Domain

	for _, user := range rec {
		userDomain = append(userDomain, user.ToDomain())
	}

	return userDomain
}

func (ur *userRepository) GetByID(id string) users.Domain {
	var user User

	ur.conn.First(&user, "id = ?", id)

	return user.ToDomain()
}

func (ur *userRepository) Delete(id string) bool {
	var user = ur.GetByID(id)

	deletedUser := FromDomain(&user)

	result := ur.conn.Delete(&deletedUser)

	return result.RowsAffected != 0
}

func (ur *userRepository) InsertURLtoUser(id string, userDomain *users.PhotoDomain) bool {
	var user = ur.GetByID(id)

	if user.ID == 0 {
		return false
	}

	ur.conn.Where("id = ?", user.ID).Select("photo").Updates(User{Photo: userDomain.Photo})
	return true
}

func (ur *userRepository) UpdateProfileData(id string, userDomain *users.Domain) users.Domain {
	var getUser = ur.GetByID(id)

	updatedUser := FromDomain(&getUser)
	updatedUser.FullName = userDomain.FullName
	updatedUser.Email = userDomain.Email
	updatedUser.Gender = userDomain.Gender
	updatedUser.Password = getUser.Password
	updatedUser.Photo = getUser.Photo
	updatedUser.Roles = getUser.Roles

	ur.conn.Save(&updatedUser)

	return updatedUser.ToDomain()
}

func (ur *userRepository) SearchByEmail(email string) users.Domain {
	var rec User

	ur.conn.First(&rec, "email = ?", email)

	return rec.ToDomain()
}
