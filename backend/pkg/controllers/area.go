package controllers

import (
	"log"
	"net/http"

	"area/pkg/models"

	"github.com/gin-gonic/gin"
)

// get all areas
func GetAreas(c *gin.Context) {
	var areas []models.Area
	models.DB.Find(&areas)
	c.JSON(http.StatusOK, gin.H{"data": areas})
}

func GetActions(c *gin.Context) {
	var actions []models.Area
	models.DB.Where("is_action = ?", true).Where("is_template = ?", true).Find(&actions)
	c.JSON(http.StatusOK, gin.H{"data": actions})
}

func GetReactions(c *gin.Context) {
	var reactions []models.Area
	models.DB.Where("is_action = ?", false).Where("is_template = ?", true).Find(&reactions)
	c.JSON(http.StatusOK, gin.H{"data": reactions})
}

func GetActionsByServiceID(c *gin.Context) {
	var actions []models.Area
	serviceID := c.Param("service_id")
	models.DB.Where("service_id = ?", serviceID).Where("is_action = ?", true).Where("is_template = ?", true).Find(&actions)
	c.JSON(http.StatusOK, gin.H{"data": actions})
}

func GetReactionsByServiceID(c *gin.Context) {
	var reactions []models.Area
	serviceID := c.Param("service_id")
	models.DB.Where("service_id = ?", serviceID).Where("is_action = ?", false).Where("is_template = ?", true).Find(&reactions)
	c.JSON(http.StatusOK, gin.H{"data": reactions})
}

type TemplateAreaInput struct {
	Name        string `json:"name" binding:"required"`
	Description string `json:"description" binding:"required"`
	IsAction    bool   `json:"isAction"` // after long search, a bool can't be required
	Config      string `json:"config" binding:"required"`
	ServiceID   uint   `json:"service_id" binding:"required"`
}

func CreateTemplateArea(c *gin.Context) {
	var input TemplateAreaInput
	if err := c.ShouldBindJSON(&input); err != nil {
		// log input
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{"could not create template area. Error : ": err.Error()})
		return
	}
	area := models.Area{Name: input.Name, Description: input.Description, IsTemplate: true, IsAction: input.IsAction, Config: input.Config, AppletID: 1, ServiceID: input.ServiceID}
	models.DB.Create(&area)
	c.JSON(http.StatusOK, gin.H{"data": area})
}

func UpdateTemplateArea(c *gin.Context) {
	var input TemplateAreaInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"could not update template area. Error : ": err.Error()})
		return
	}
	area := models.Area{Name: input.Name, Description: input.Description, IsAction: input.IsAction, Config: input.Config, AppletID: 1, ServiceID: input.ServiceID}
	models.DB.Save(&area)
	c.JSON(http.StatusOK, gin.H{"data": area})
}

func DeleteTemplateArea(c *gin.Context) {
	var area models.Area
	if err := models.DB.Where("id = ?", c.Param("id")).First(&area).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "could not find area"})
		return
	}
	models.DB.Delete(&area)
	c.JSON(http.StatusOK, gin.H{"data": true})
}

type AreaInput struct {
	Name        string `json:"name" binding:"required"`
	Description string `json:"description" binding:"required"`
	IsAction    bool   `json:"isAction" binding:"required"`
	Config      string `json:"config" binding:"required"`
	Params      string `json:"params" binding:"required"`
	AppletID    int    `json:"applet_id" binding:"required"`
}
