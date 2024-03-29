package controllers

import (
	"log"
	"net/http"

	"area/pkg/models"

	"github.com/gin-gonic/gin"
)

type CreateUserInput struct {
	FirstName string `json:"first_name" binding:"required"`
	LastName  string `json:"last_name" binding:"required"`
	Email     string `json:"email" binding:"required"`
	Password  string `json:"password" binding:"required"`
}

func CreateUser(c *gin.Context) {
	var input CreateUserInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// check if the email already exists in the database
	var userCheck models.User
	if result := models.DB.Where("email = ?", input.Email).First(&userCheck); result.Error == nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Email already exists"})
		return
	}
	user := models.User{FirstName: input.FirstName, LastName: input.LastName, Email: input.Email, Password: input.Password}
	models.DB.Create(&user)

	c.JSON(http.StatusOK, gin.H{"data": user})
}

func GetUser(c *gin.Context) {
	var user models.User
	id := c.Param("id")

	log.Println("GetUser request received")
	if result := models.DB.First(&user, id); result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Record not found!"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": user})
}

// GetUsers func
func GetUsers(c *gin.Context) {
	var users []models.User

	log.Println("GetUsers request received")
	if result := models.DB.Find(&users); result.Error != nil {
		panic(result.Error)
	}
	c.JSON(http.StatusOK, gin.H{"data": users})
}

type UpdateUserInput struct {
	FirstName string `json:"first_name" binding:"required"`
	LastName  string `json:"last_name" binding:"required"`
	Email     string `json:"email" binding:"required"`
	Password  string `json:"password" binding:"required"`
}

func UpdateUser(c *gin.Context) {
	var user models.User
	id := c.Param("id")

	log.Println("UpdateUser request received")
	if result := models.DB.First(&user, id); result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Record not found!"})
		return
	}

	var input UpdateUserInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	updateUser := models.User{FirstName: input.FirstName, LastName: input.LastName, Email: input.Email, Password: input.Password}
	models.DB.Model(&user).Updates(updateUser)

	c.JSON(http.StatusOK, gin.H{"data": user})
}

func DeleteUser(c *gin.Context) {
	var user models.User
	id := c.Param("id")

	log.Println("DeleteUser request received")
	if result := models.DB.First(&user, id); result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Record not found!"})
		return
	}
	models.DB.Delete(&user)
	c.JSON(http.StatusOK, gin.H{"data": true})
}

// GetProfile func
