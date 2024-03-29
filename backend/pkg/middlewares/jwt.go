package middlewares

import (
	"errors"
	"log"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v4"
)

func VerifyJWT(endpointHandler func(c *gin.Context)) gin.HandlerFunc {
	return gin.HandlerFunc(func(c *gin.Context) {
		auth := c.GetHeader("Authorization")
		if auth == "" {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Token not found"})
			c.Abort()
			return
		}
		tokenString := auth
		tokenString = tokenString[7:]
		token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
			_, ok := token.Method.(*jwt.SigningMethodHMAC)
			if !ok {
				c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token signature (1)"})
			}
			secretKey := os.Getenv("SERVER_JWT_SECRET")
			return []byte(secretKey), nil
		})
		if err != nil {
			log.Println(err)
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token (3)"})
			c.Abort()
			return
		}
		if token.Valid {
			claims := token.Claims.(jwt.MapClaims)
			log.Println(claims["email"], claims["exp"], claims["issued"], claims["user_id"])
			c.Next()
		} else {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token (4)"})
			c.Abort()
			return
		}
		endpointHandler(c)
	})
}

func GetUserIDFromJWT(auth string) (uint, error) {
	if auth == "" {
		return 0, errors.New("Authorization header empty!")
	}

	token, err := jwt.Parse(auth[7:], func(token *jwt.Token) (interface{}, error) {
		_, ok := token.Method.(*jwt.SigningMethodHMAC)
		if !ok {
			return 0, errors.New("Invalid token signature")
		}
		secretKey := os.Getenv("SERVER_JWT_SECRET")
		return []byte(secretKey), nil
	})

	if err != nil {
		return 0, err
	} else if token.Valid {
		claims := token.Claims.(jwt.MapClaims)
		userID := claims["user_id"].(uint)
		log.Println("userID: ", userID)
		return userID, nil
	} else {
		return 0, errors.New("Invalid token")
	}
}
