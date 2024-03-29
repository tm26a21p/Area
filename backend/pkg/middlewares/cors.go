package middlewares

import (
	"time"
	
	"github.com/gin-gonic/gin"
	cors "github.com/itsjamie/gin-cors"
)

func GetCorsHandler() gin.HandlerFunc {
	config := cors.Config{
		Origins:         "*",
		Methods:         "GET, PUT, POST, DELETE",
		RequestHeaders:  "Origin, Authorization, Content-Type",
		ExposedHeaders:  "",
		MaxAge:          50 * time.Second,
		Credentials:     false,
		ValidateHeaders: false,
	}
	handler := cors.Middleware(config)
	
	return handler
}