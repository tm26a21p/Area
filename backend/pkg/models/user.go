package models

import "gorm.io/gorm"

type User struct {
	gorm.Model        // can be used to add some default fields to the model (ID, CreatedAt, UpdatedAt, DeletedAt)
	FirstName  string `json:"first_name"`
	LastName   string `json:"last_name"`
	Email      string `json:"email"`
	Password   string `json:"password"`
	Avatar     string `json:"avatar"`
	UUID       string `json:"uuid"`
}
