package utils

import (
	"area/pkg/models"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

type Myareas struct {
	Name        string `json:"name"`
	Description string `json:"description"`
}

type Myservice struct {
	Name     string    `json:"name"`
	Action   []Myareas `json:"actions"`
	Reaction []Myareas `json:"reactions"`
}

type serverStruct struct {
	Current_time string      `json:"current_time"`
	Service      []Myservice `json:"services"`
}

type data struct {
	Client gin.H        `json:"client"`
	Server serverStruct `json:"server"`
}

func About(c *gin.Context) {
	// Get services list
	var services []models.Service

	if result := models.DB.Find(&services); result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Record not found!"})
		return
	}

	// get action list
	var area []models.Area

	ActionData := make([][]Myareas, len(services))
	for x := 0; x < len(services); x++ {
		models.DB.Where("service_id = ?", services[x].ID).Where("is_action = ?", true).Where("is_template = ?", true).Find(&area)
		ActionData[x] = make([]Myareas, len(area))
		for y := 0; y < len(area); y++ {
			ActionData[x][y].Name = area[y].Name
			ActionData[x][y].Description = area[y].Description
		}
	}

	// Get Reaction list

	ReactionData := make([][]Myareas, len(services))
	for x := 0; x < len(services); x++ {
		models.DB.Where("service_id = ?", services[x].ID).Where("is_action = ?", false).Where("is_template = ?", true).Find(&area)
		ReactionData[x] = make([]Myareas, len(area))
		for y := 0; y < len(area); y++ {
			ReactionData[x][y].Name = area[y].Name
			ReactionData[x][y].Description = area[y].Description
		}
	}

	// Fill server and Client
	host := gin.H{"host": c.ClientIP()}
	mytime := strconv.FormatInt(time.Now().Unix(), 10)
	servicesdata := make([]Myservice, len(services))
	for i := 0; i < len(services); i++ {
		servicesdata[i].Name = services[i].Name
		servicesdata[i].Action = ActionData[i]
		servicesdata[i].Reaction = ReactionData[i]
	}
	myserver := serverStruct{Current_time: mytime, Service: servicesdata}
	mydata := data{Client: host,
		Server: myserver}
	c.IndentedJSON(http.StatusOK, mydata)
}
