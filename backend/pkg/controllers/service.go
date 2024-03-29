package controllers

import (
	"fmt"
	"log"
	"net/http"

	"area/pkg/models"

	"github.com/gin-gonic/gin"
)

// CreateServiceInput struct
type CreateServiceInput struct {
	Name        string `json:"name" binding:"required"`
	Description string `json:"description" binding:"required"`
}

// CreateService function
func CreateService(c *gin.Context) {
	var input CreateServiceInput
	if err := c.ShouldBindJSON(&input); err != nil {
		fmt.Println("error is : ", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	service := models.Service{Name: input.Name, Description: input.Description}
	models.DB.Create(&service)
	c.JSON(http.StatusOK, gin.H{"data": service})
}

func GetService(c *gin.Context) {
	var service models.Service
	id := c.Param("id")

	if result := models.DB.First(&service, id); result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Record not found!"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": service})
}

// GetServices func
func GetServices(c *gin.Context) {
	var services []models.Service

	if result := models.DB.Find(&services); result.Error != nil {
		panic(result.Error)
	}
	c.JSON(http.StatusOK, gin.H{"data": services})
}

// UpdateServiceInput struct
type UpdateServiceInput struct {
	Name        string `json:"name" binding:"required"`
	Description string `json:"description" binding:"required"`
}

// UpdateService function
func UpdateService(c *gin.Context) {
	var service models.Service
	id := c.Param("id")

	log.Println("UpdateService request received")
	if result := models.DB.First(&service, id); result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Record not found!"})
		return
	}

	var input UpdateServiceInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	updateService := models.Service{Name: input.Name, Description: input.Description}
	models.DB.Model(&service).Updates(updateService)

	c.JSON(http.StatusOK, gin.H{"data": service})
}

// DeleteService func
func DeleteService(c *gin.Context) {
	var service models.Service
	id := c.Param("id")

	log.Println("DeleteService request received")
	if result := models.DB.First(&service, id); result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Record not found!"})
		return
	}

	models.DB.Delete(&service)
	c.JSON(http.StatusOK, gin.H{"data": true})
}
