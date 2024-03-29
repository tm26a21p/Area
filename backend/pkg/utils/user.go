package utils

import (
	"area/pkg/models"

	"gorm.io/gorm"
)

func DoesUserExists(userID uint) bool {
	var userCheck []models.User

	result := models.DB.Where("id = ?", userID).Find(&userCheck)
	return result.Error != gorm.ErrRecordNotFound
}
