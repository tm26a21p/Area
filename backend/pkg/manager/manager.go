package manager

import (
	"errors"
	// "log"

	"area/pkg/models"
	"area/pkg/service"
	"area/pkg/utils"
)

// Globals

var actionsMap = map[string]func(tokenRaw models.Token, reactions []utils.Reaction, userID uint, channel chan models.AppletStatus){
	"EveryMinute":        service.EveryMinute,
	"EveryHour":          service.EveryHour,
	"EveryDay":           service.EveryDay,
	"EveryWeek":          service.EveryWeek,
	"EveryMonth":         service.EveryMonth,
	"ReceiveGoogleEmail": service.ReceiveGoogleEmail,
	// "ReceiveFileGoogleDrive": service.ReceiveFileGoogleDrive,
}

var reactionsMap = map[string]func(tokenRaw models.Token, params string){
	"GetUserContacts":           service.GetUserContacts,
	"CreateUserContact":         service.CreateUserContact,
	"DeleteUserContact":         service.DeleteUserContact,
	"DropGnomePotion":           service.DropGnomePotion,
	"SendGoogleEmail":           service.SendGoogleEmail,
	"GmailEmptyTrash":           service.GmailEmptyTrash,
	"SendGoogleEmailToYourself": service.SendGoogleEmailToYourself,
	"CommentYoutubeVideo":       service.CommentYoutubeVideo,
	"LikeYoutubeVideo":          service.LikeYoutubeVideo,
	"DislikeYoutubeVideo":       service.DislikeYoutubeVideo,
	"SubscribeYoutubeChannel":   service.SubscribeYoutubeChannel,
	"CreateEvent":               service.CreateEvent,
	"CreateWeeklyEvent":         service.CreateWeeklyEvent,
	"DeleteAllDayEvent":         service.DeleteAllDayEvent,
	"CreateGoogleDocsDocument":  service.CreateGoogleDocsDocument,
	"CreateSimpleForms":         service.CreateSimpleForms,
	"EmptyTrashGoogleDrive":	 service.EmptyTrashGoogleDrive,
}

var appletsMap = make(map[uint]chan models.AppletStatus)

// Functions
func getApplet(appletID uint) models.Applet {
	var applet models.Applet
	models.DB.Where("id = ?", appletID).Preload("Areas").Find(&applet)
	return applet
}

func GetAllActiveApplets() []models.Applet {
	var applets []models.Applet
	// get all applets with a running status
	models.DB.Where("running_status = ?", models.RUN).Preload("Areas").Find(&applets)
	return applets
}

func getAction(applet models.Applet) utils.Action {
	var action utils.Action

	for _, area := range applet.Areas {
		if area.IsAction {
			action.Name = area.Name
			action.Params = area.Params
			action.Function = actionsMap[area.FunctionName]
			return action
		}
	}
	return utils.Action{}
}

func getReaction(applet models.Applet) []utils.Reaction {
	var reactions []utils.Reaction

	for _, area := range applet.Areas {
		if !area.IsAction {
			reactions = append(reactions, utils.Reaction{
				Name:      area.Name,
				Params:    area.Params,
				ServiceID: area.ServiceID,
				AppletID:  applet.ID,
				Function:  reactionsMap[area.FunctionName],
			})
		}
	}
	return reactions
}

func getTokenFromUserID(userID uint) models.Token {
	var token models.Token
	models.DB.Where("user_id = ?", userID).Find(&token)
	return token
}

func launchApplet(applet models.Applet) {
	action := getAction(applet)
	reactions := getReaction(applet)

	appletsMap[applet.ID] = make(chan models.AppletStatus)
	token := getTokenFromUserID(applet.UserID)
	go action.Function(token, reactions, applet.UserID, appletsMap[applet.ID])
	appletsMap[applet.ID] <- models.RUN
}

func firstRun() {
	applets := GetAllActiveApplets()

	for _, applet := range applets {
		launchApplet(applet)
	}
}

func UpdateAppletStatus(id uint, status models.AppletStatus) error {
	_, ok := appletsMap[id]

	if !ok {
		return errors.New("no such applet")
	}
	appletsMap[id] <- status
	return nil
}

func RemoveAppletFromMap(id uint) {
	appletsMap[id] <- models.STOP
	delete(appletsMap, id)
}

func Run(dataChannel chan utils.Packet) {
	firstRun()

	for {
		data := <-dataChannel
		launchApplet(getApplet(data.AppletID))
	}
}
