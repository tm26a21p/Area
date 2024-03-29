package models

import (
	"golang.org/x/oauth2"
	"gorm.io/gorm"
)

type Token struct {
	gorm.Model
	ServiceName            string       `json:"service_name"`
	AccessToken            oauth2.Token `json:"access_token" gorm:"embedded"`
	AssociatedEmailAddress string       `json:"associated_email_address"`
	UserID                 uint         `json:"user_id"`
	User                   User
}
