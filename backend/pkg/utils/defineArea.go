package utils

import (
	"area/pkg/models"
)

type Action struct {
	Name     string
	Params   string
	Function func(tokenRaw models.Token, reactions []Reaction, userID uint, channel chan models.AppletStatus)
}

type Reaction struct {
	Name      string
	Params    string
	ServiceID uint
	AppletID  uint
	Function  func(tokenRaw models.Token, params string)
}

type Packet struct {
	AppletID     uint
	AppletStatus models.AppletStatus
	Areas        []models.Area
}

var PacketChannel = make(chan Packet)

func CreatePacket(id uint, status models.AppletStatus, areas []models.Area) Packet {
	return Packet{
		AppletID:     id,
		AppletStatus: status,
		Areas:        areas,
	}
}

func SendPacketToManager(packet Packet) {
	PacketChannel <- packet
}
