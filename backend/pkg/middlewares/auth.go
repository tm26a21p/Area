package middlewares

import (
	"net/http"
	"strconv"

	"area/pkg/utils"

	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
)

type ServiceInput struct {
	Name string `json:"service_name"`
}

func IsUserConnectedToService() gin.HandlerFunc {
	return func(c *gin.Context) {
		userID, err := strconv.ParseUint(c.Param("user_id"), 10, 64)
		var body ServiceInput

		if err := c.ShouldBindBodyWith(&body, binding.JSON); err != nil {
			c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		if err != nil {
			c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		alreadyConnected, err := utils.IsUserConnectedToService(body.Name, uint(userID))
		if err != nil {
			c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		} else if !alreadyConnected {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "user is not connected to service"})
		} else {
			c.Next()
		}
	}
}
