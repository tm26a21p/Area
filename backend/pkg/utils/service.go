package utils

import (
	"area/pkg/models"

	"gorm.io/gorm"
)

func DoesServiceExists(name string) bool {
	var serviceCheck []models.Service

	result := models.DB.Where("name = ?", name).Find(&serviceCheck)
	return result.Error != gorm.ErrRecordNotFound
}
