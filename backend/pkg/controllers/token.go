package controllers

import (
	"area/pkg/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func GetTokensHandler(c *gin.Context) {
	tokens, err := utils.GetTokens()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": tokens})
}

func GetUserServiceTokenHandler(c *gin.Context) {
	userID, err := strconv.ParseUint(c.Param("user_id"), 10, 64)
	serviceName := c.Param("service_name")

	if err != nil {
		c.JSON(http.StatusBadRequest, "user id isn't a number.")
		return
	}
	tokens, err := utils.GetUserServiceToken(serviceName, uint(userID))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": tokens})
}

func IsUserConnectedToServiceHandler(c *gin.Context) {
	userID, err := strconv.ParseUint(c.Param("user_id"), 10, 64)
	serviceName := c.Param("service_name")

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	alreadyConnected, err := utils.IsUserConnectedToService(serviceName, uint(userID))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusAccepted, alreadyConnected)
}
