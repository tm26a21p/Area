package controllers

import (
	"context"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"

	"area/pkg/models"
	"area/pkg/utils"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
	"golang.org/x/oauth2"
)

// LoginInput struct
type LoginInput struct {
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type LoginResponse struct {
	ID        uint   `json:"id"`
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
	Email     string `json:"email"`
	Token     string `json:"token"`
	Avatar    string `json:"avatar"`
	Uuid      string `json:"uuid"`
}

// Login function
func Login(c *gin.Context) {
	var input LoginInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// check if the email exists in the database
	var user models.User
	if result := models.DB.Where("email = ?", input.Email).First(&user); result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Email not found"})
		return
	}

	// check if the password is correct
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(input.Password)); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid password"})
		return
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
		Uuid:      tokenID,
	}

	c.JSON(http.StatusOK, gin.H{"user": response})
}

// RegisterInput struct
type RegisterInput struct {
	FirstName string `json:"first_name" binding:"required"`
	LastName  string `json:"last_name" binding:"required"`
	Email     string `json:"email" binding:"required"`
	Password  string `json:"password" binding:"required"`
}

// Register function
func Register(c *gin.Context) {
	var input RegisterInput
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

	// hash the password
	passwordHash, err := bcrypt.GenerateFromPassword([]byte(input.Password), bcrypt.DefaultCost)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Error hashing password"})
		return
	}

	user := models.User{FirstName: input.FirstName, LastName: input.LastName, Email: input.Email, Password: string(passwordHash)}
	models.DB.Create(&user)

	c.JSON(http.StatusOK, gin.H{"data": user})
}

// Logout function
func Logout(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"data": "logout"})
}

func GetServiceOAuth2Config(serviceName string, scopes []string, redirectUri string) (*oauth2.Config, error) {
	serviceConfig, ok := utils.ServiceConfigs[serviceName]
	if !ok {
		return nil, errors.New("no such services")
	}

	config := &oauth2.Config{
		ClientID:     os.Getenv(serviceConfig.EnvPrefix + "_CLIENT_ID"),
		ClientSecret: os.Getenv(serviceConfig.EnvPrefix + "_CLIENT_SECRET"),
		RedirectURL:  redirectUri,
		Scopes:       scopes,
		Endpoint:     serviceConfig.Endpoint,
	}
	return config, nil
}

type ConnectToServiceInput struct {
	ServiceName string   `json:"service_name"`
	UserID      uint     `json:"user_id"`
	Scopes      []string `json:"scopes"`
	RedirectUri string   `json:"redirect_uri"`
	AuthCode    string   `json:"authorization_code"`
}

func ConnectToService(input ConnectToServiceInput) (models.Token, error) {
	config, err := GetServiceOAuth2Config(input.ServiceName, input.Scopes, input.RedirectUri)
	if err != nil {
		return models.Token{}, err
	}

	toks, err := config.Exchange(context.TODO(), input.AuthCode)
	if err != nil {
		return models.Token{}, err
	}

	tokInput := utils.TokenInput{
		ServiceName: input.ServiceName,
		AccessToken: *toks,
		UserID:      input.UserID,
	}

	resTok, err := utils.CreateServiceToken(tokInput)
	if err != nil {
		return models.Token{}, err
	}

	return resTok, nil
}

type ConnectToServiceBody struct {
	AuthCode    string `json:"code"`
	Scope       string `json:"scope"`
	RedirectUri string `json:"redirect_uri"`
	Service     string `json:"service_name"`
}

type ServiceInput struct {
	Name string `json:"service_name"`
}

func ConnectToServiceHandler(c *gin.Context) {
	userID, err := strconv.ParseUint(c.Param("user_id"), 10, 64)
	var body ConnectToServiceBody

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	input := ConnectToServiceInput{
		ServiceName: body.Service,
		UserID:      uint(userID),
		Scopes:      []string{body.Scope},
		RedirectUri: body.RedirectUri,
		AuthCode:    body.AuthCode,
	}

	resTok, err := ConnectToService(input)
	if err != nil {
		log.Println("Error at service connection: ", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	res := fmt.Sprintf("User %d successfully connected to service %s.", resTok.UserID, resTok.ServiceName)
	log.Println("Connection success:", res)
	c.JSON(http.StatusOK, gin.H{"response": res})
}

func DeconnectToServiceHandler(c *gin.Context) {
	userID, err := strconv.ParseUint(c.Param("user_id"), 10, 64)
	var body ServiceInput

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = utils.DeleteServiceToken(body.Name, uint(userID))

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"response": "token successfully revoked"})
}
