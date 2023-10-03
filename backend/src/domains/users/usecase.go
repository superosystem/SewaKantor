package users

import (
	"github.com/superosystem/SewaKantor/backend/src/applications/middlewares"
	"strconv"
)

type UserUsecase struct {
	userRepository Repository
	jwtAuth        *middlewares.ConfigJWT
}

func NewUserUsecase(ur Repository, jwtAuth *middlewares.ConfigJWT) Usecase {
	return &UserUsecase{
		userRepository: ur,
		jwtAuth:        jwtAuth,
	}
}

func (uu *UserUsecase) Register(userDomain *Domain) Domain {
	return uu.userRepository.Register(userDomain)
}

func (uu *UserUsecase) Login(userDomain *LoginDomain) map[string]string {
	tokenPair := make(map[string]string)

	user := uu.userRepository.GetByEmail(userDomain)

	if user.ID == 0 {
		return tokenPair
	}

	token := uu.jwtAuth.GenerateTokenPair(strconv.Itoa(int(user.ID)), user.Roles)
	tokenPair["access_token"] = token.AccessToken
	tokenPair["refresh_token"] = token.RefreshToken

	return tokenPair
}

func (uu *UserUsecase) Token(userId string, roles string) map[string]string {
	tokenPair := make(map[string]string)

	token := uu.jwtAuth.GenerateTokenPair(userId, roles)
	tokenPair["access_token"] = token.AccessToken
	tokenPair["refresh_token"] = token.RefreshToken

	return tokenPair
}

func (uu *UserUsecase) GetAll() []Domain {
	return uu.userRepository.GetAll()
}

func (uu *UserUsecase) GetByID(id string) Domain {
	return uu.userRepository.GetByID(id)
}

func (uu *UserUsecase) GetProfile(id string) Domain {
	return uu.userRepository.GetByID(id)
}

func (uu *UserUsecase) Delete(id string) bool {
	return uu.userRepository.Delete(id)
}

func (uu *UserUsecase) UpdateProfilePhoto(id string, userDomain *PhotoDomain) bool {
	return uu.userRepository.InsertURLtoUser(id, userDomain)
}

func (uu *UserUsecase) UpdateProfileData(id string, userDomain *Domain) Domain {
	isEmailExist := uu.userRepository.CheckUserByEmailOnly(id, userDomain.Email)

	if isEmailExist {
		userDomain.ID = 0
		return *userDomain
	}

	return uu.userRepository.UpdateProfileData(id, userDomain)
}

func (uu *UserUsecase) SearchByEmail(email string) Domain {
	return uu.userRepository.SearchByEmail(email)
}
