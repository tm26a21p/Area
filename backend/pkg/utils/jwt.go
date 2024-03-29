package utils

import (
	"log"
	"os"
	"time"

	"github.com/golang-jwt/jwt/v4"
	"github.com/google/uuid"
)

func newPayload(email string) (jwt.MapClaims, string, error) {
	tokenID, err := uuid.NewRandom()

	if err != nil {
		log.Println(err)
		return nil, "", err
	}
	return jwt.MapClaims{
		"user_id": tokenID.String(),
		"email":   email,
		"issued":  time.Now().Unix(),
		"exp":     time.Now().Add(time.Hour * 24).Unix(),
	}, tokenID.String(), nil
}

func GenerateJWT(email string, user_id uint) (string, string, error) {
	secretKey := os.Getenv("SERVER_JWT_SECRET")

	payload, tokenID, err := newPayload(email)
	if err != nil {
		return "", "", err
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, payload)

	tokenString, err := token.SignedString([]byte(secretKey))
	if err != nil {
		log.Println(err)
		return "", "", err
	}

	return tokenString, tokenID, nil
}
