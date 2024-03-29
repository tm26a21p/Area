package models

import (
	"gorm.io/gorm"
)

type Area struct {
	gorm.Model
	Name         string `json:"name"`
	Description  string `json:"description"`
	IsTemplate   bool   `json:"isTemplate"`
	IsAction     bool   `json:"isAction"`
	FunctionName string `json:"function_name"`
	Config       string `json:"config"`
	Params       string `json:"params"`
	AppletID     uint   `json:"applet_id"`
	ServiceID    uint   `json:"service_id"`
	Service      Service
}
