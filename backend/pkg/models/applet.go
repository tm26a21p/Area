package models

import "gorm.io/gorm"

type AppletStatus uint

const (
	RUN   AppletStatus = 0
	PAUSE AppletStatus = 1
	STOP  AppletStatus = 2
)

type Applet struct {
	gorm.Model
	Name          string       `json:"name"`
	RunningStatus AppletStatus `json:"running_status"`
	Status        bool         `json:"status"`
	Areas         []Area       `json:"areas"`
	UserID        uint         `json:"user_id"`
	User          User
}
