package controllers

import (
	"net/http"

	"area/pkg/manager"
	"area/pkg/models"
	"area/pkg/utils"

	"github.com/gin-gonic/gin"
)

type AppletInput struct {
	UserID    uint          `json:"user_id"`
	Name      string        `json:"name"`
	Action    models.Area   `json:"action"`
	Reactions []models.Area `json:"reactions"`
}

func GetAppletsByUserID(c *gin.Context) {
	var applets []models.Applet
	id := c.Param("id")
	models.DB.Preload("Areas").Where("user_id = ?", id).Find(&applets)
	c.JSON(200, gin.H{"data": applets})
}

func GetAppletAloneByUserID(c *gin.Context) {
	var applet models.Applet
	id := c.Param("id")
	models.DB.Preload("Areas").Where("id = ?", id).First(&applet)
	c.JSON(200, gin.H{"data": applet})
}

func CreateApplet(c *gin.Context) {
	var input AppletInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(400, gin.H{"error CreateApplet =>": err.Error()})
		return
	}
	applet := models.Applet{Name: input.Name, UserID: input.UserID, RunningStatus: models.RUN, Status: true}
	models.DB.Create(&applet)
	var actionModel models.Area
	models.DB.Where("id = ?", input.Action.ID).First(&actionModel)
	var areas []models.Area
	action := models.Area{
		Name:         actionModel.Name,
		IsAction:     true,
		FunctionName: actionModel.FunctionName,
		Config:       "config",
		Params:       "params",
		ServiceID:    actionModel.ServiceID,
		AppletID:     applet.ID,
	}
	areas = append(areas, action)
	models.DB.Create(&action)
	for _, reaction := range input.Reactions {
		var reactionModel models.Area
		models.DB.Where("id = ?", reaction.ID).First(&reactionModel)
		reaction := models.Area{
			Name:         reactionModel.Name,
			FunctionName: reactionModel.FunctionName,
			Config:       reactionModel.Config,
			Params:       reaction.Params,
			ServiceID:    reactionModel.ServiceID,
			AppletID:     applet.ID,
		}
		areas = append(areas, reaction)
		models.DB.Create(&reaction)
	}
	packet := utils.CreatePacket(applet.ID, applet.RunningStatus, areas)
	utils.SendPacketToManager(packet)
	c.JSON(200, gin.H{"data": applet})
}

func ToggleApplet(c *gin.Context) {
	var applet models.Applet
	var newStatus models.AppletStatus

	id := c.Param("id")
	models.DB.Where("id = ?", id).First(&applet)
	if applet.RunningStatus == models.RUN {
		newStatus = models.PAUSE
	} else if applet.RunningStatus == models.PAUSE {
		newStatus = models.RUN
	}

	applet.Status = !applet.Status
	applet.RunningStatus = newStatus
	err := manager.UpdateAppletStatus(applet.ID, newStatus)
	if err != nil {
		c.JSON(http.StatusOK, gin.H{"error": err.Error()})
		return
	}
	models.DB.Save(&applet)
	c.JSON(200, gin.H{"data": applet})
}

func UpdateApplet(c *gin.Context) {
	var input AppletInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(400, gin.H{"error UpdateApplet =>": err.Error()})
		return
	}
	id := c.Param("id")
	applet := models.Applet{Name: input.Name, UserID: input.UserID}
	models.DB.Model(&applet).Where("id = ?", id).Updates(applet)
	models.DB.Model(&applet).Association("Areas").Replace(input.Reactions)
	c.JSON(200, gin.H{"data": applet})
}

func DeleteApplet(c *gin.Context) {
	id := c.Param("id")
	models.DB.Delete(&models.Applet{}, id)
	c.JSON(200, gin.H{"data": true})
}
