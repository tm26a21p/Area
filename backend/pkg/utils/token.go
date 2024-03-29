package utils

import (
	"area/pkg/models"
	"errors"

	"golang.org/x/oauth2"
	"golang.org/x/oauth2/endpoints"
	"gorm.io/gorm"
)

var (
	ErrUserNotFound       = errors.New("user doesn't exists")
	ErrServiceNotFound    = errors.New("service doesn't exists")
	ErrTokenNotFound      = errors.New("token doesn't exists")
	ErrTokenAlreadyExists = errors.New("token already exists")
)

func GetTokens() ([]models.Token, error) {
	var tokens []models.Token

	if result := models.DB.Find(&tokens); result.Error != nil {
		return nil, result.Error
	}
	return tokens, nil
}

func GetUserTokens(userID int) ([]models.Token, error) {
	var tokens []models.Token

	if !DoesUserExists(uint(userID)) {
		return nil, ErrUserNotFound
	}

	result := models.DB.Where("user_id = ?", userID).Find(&tokens)
	if result.Error != nil {
		return nil, result.Error
	}
	return tokens, nil
}

func GetUserServiceToken(serviceName string, userID uint) (models.Token, error) {
	var token models.Token

	if !DoesUserExists(uint(userID)) {
		return models.Token{}, ErrUserNotFound
	} else if !DoesServiceExists(serviceName) {
		return models.Token{}, ErrServiceNotFound
	}

	result := models.DB.Where("service_name = ?", serviceName).Where("user_id = ?", userID).First(&token)
	if result.Error == gorm.ErrRecordNotFound {
		return models.Token{}, ErrTokenNotFound
	} else if result.Error != nil {
		return models.Token{}, result.Error
	}

	return token, nil
}

func IsUserConnectedToService(serviceName string, userID uint) (bool, error) {
	var checkToken models.Token

	if !DoesUserExists(uint(userID)) {
		return false, ErrUserNotFound
	}

	result := models.DB.Where("service_name = ?", serviceName).Where("user_id = ?", userID).First(&checkToken)
	if result.Error == gorm.ErrRecordNotFound {
		return false, nil
	} else if result.Error != nil {
		return false, result.Error
	} else {
		return true, nil
	}
}

func getTokenAssociatedEmailAddress(serviceName string, token *oauth2.Token) (string, error) {
	serviceConfig, ok := ServiceConfigs[serviceName]
	if !ok {
		return "", ErrServiceNotFound
	}

	if serviceConfig.Endpoint == endpoints.Google {
		email, err := GetGoogleAssociatedEmailAddress(token)
		if err != nil {
			return "", err
		}
		return email, nil
	}

	return "", errors.New("This service does is not supported (can't get associated email address)")
}

type TokenInput struct {
	ServiceName string       `json:"service_name"`
	AccessToken oauth2.Token `json:"access_token"`
	UserID      uint         `json:"user_id"`
}

func CreateServiceToken(new TokenInput) (models.Token, error) {
	alreadyConnected, err := IsUserConnectedToService(new.ServiceName, new.UserID)
	if err != nil {
		return models.Token{}, nil
	} else if alreadyConnected {
		return models.Token{}, ErrTokenAlreadyExists
	}

	email, err := getTokenAssociatedEmailAddress(new.ServiceName, &new.AccessToken)
	if err != nil {
		return models.Token{}, err
	}

	token := models.Token{
		ServiceName:            new.ServiceName,
		AccessToken:            new.AccessToken,
		AssociatedEmailAddress: email,
		UserID:                 new.UserID,
	}
	result := models.DB.Create(&token)
	if result.Error != nil {
		return models.Token{}, result.Error
	}

	return token, nil
}

func UpdateServiceToken(updated TokenInput) (models.Token, error) {
	alreadyConnected, err := IsUserConnectedToService(updated.ServiceName, updated.UserID)

	if err != nil {
		return models.Token{}, err
	} else if !alreadyConnected {
		return CreateServiceToken(updated)
	}

	token := models.Token{
		ServiceName: updated.ServiceName,
		AccessToken: updated.AccessToken,
		UserID:      updated.UserID,
	}
	models.DB.Save(&token)
	return token, nil
}

func DeleteServiceToken(serviceName string, userID uint) error {
	serviceToken, err := GetUserServiceToken(serviceName, userID)
	if err != nil {
		return err
	}

	models.DB.Delete(&serviceToken)
	return nil
}

func DeleteAllTokens(userID int) error {
	tokens, err := GetUserTokens(userID)
	if err != nil {
		return err
	}

	models.DB.Delete(&tokens)
	return nil
}
