package models

import "gorm.io/gorm"

type ServiceButton struct {
	Provider              string `json:"provider"`
	ClientID              string `json:"client_id"`
	RedirectURI           string `json:"redirect_uri"`
	AuthorizationEndpoint string `json:"auth"`
	Scopes                string `json:"scopes"`
}

type Service struct {
	gorm.Model
	Name        string        `json:"name"`
	Description string        `json:"description"`
	Color       string        `json:"color"`
	Icon        string        `json:"icon"`
	Button      ServiceButton `json:"button" gorm:"embedded"`
}
