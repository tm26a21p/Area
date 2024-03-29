package controllers

import (
	"log"
	"net/http"
	"os"

	"area/pkg/models"

	"area/pkg/utils"

	"github.com/gin-gonic/gin"
	"github.com/goccy/go-json"
	"google.golang.org/api/idtoken"
	"gorm.io/gorm"
)

func GoogleLogin(c *gin.Context) {
	cookie, err := c.Request.Cookie("g_csrf_token")
	BodyToken := c.PostForm("g_csrf_token")

	if err != nil {
		log.Println("error is 1: ", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	cookieToken := cookie.Value
	// if the cookie token and the body token are not the same, return an error
	if cookieToken != BodyToken {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid CSRF token"})
		return
	}
	token := c.PostForm("credential")
	googleClientID := os.Getenv("LOUIS_GOOGLE_CLIENT_ID")
	payload, err := idtoken.Validate(c.Request.Context(), token, googleClientID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	email := payload.Claims["email"].(string)
	// check if the email exists in the database
	var user models.User
	if result := models.DB.Where("email = ?", email).First(&user); result.Error != nil {
		user.Email = email
		user.FirstName = payload.Claims["given_name"].(string)
		user.LastName = payload.Claims["family_name"].(string)
		user.Password = "google"
		user.Avatar = payload.Claims["picture"].(string)
		models.DB.Create(&user)
	}
	tokenString, tokenID, err := utils.GenerateJWT(user.Email, user.ID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Error while generating token"})
		return
	}
	// replace or create the tokenID in the user table
	user.UUID = tokenID
	models.DB.Save(&user)
	response := LoginResponse{
		ID:        user.ID,
		FirstName: user.FirstName,
		LastName:  user.LastName,
		Email:     user.Email,
		Token:     tokenString,
		Avatar:    user.Avatar,
		Uuid:      user.UUID,
	}
	stringResponse, _ := json.Marshal(response)
	hostname := c.Request.Host
	hostname = hostname[:len(hostname)-5]
	c.SetCookie("user", string(stringResponse), 3600, "/", hostname, false, false)
	c.Redirect(http.StatusMovedPermanently, "http://localhost:8081/explore")
}

type NativeGoogleLoginInput struct {
	Email     string `json:"email"`
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
	Avatar    string `json:"avatar"`
}

func NativeGoogleLogin(c *gin.Context) {
	var body NativeGoogleLoginInput
	var user models.User

	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if result := models.DB.Where("email = ?", body.Email).First(&user); result.Error == gorm.ErrRecordNotFound {
		user.Email = body.Email
		user.FirstName = body.FirstName
		user.LastName = body.LastName
		user.Password = "google"
		user.Avatar = body.Avatar
		models.DB.Create(&user)
	} else if result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": result.Error.Error()})
		return
	}

	tokenString, tokenID, err := utils.GenerateJWT(user.Email, user.ID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	user.UUID = tokenID
	models.DB.Save(&user)
	response := LoginResponse{
		ID:        user.ID,
		FirstName: user.FirstName,
		LastName:  user.LastName,
		Email:     user.Email,
		Token:     tokenString,
		Avatar:    user.Avatar,
		Uuid:      user.UUID,
	}
	c.JSON(http.StatusOK, response)
}
