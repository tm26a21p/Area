package service

import (
	"log"
	"time"

	"area/pkg/models"
	"area/pkg/utils"

	"github.com/go-co-op/gocron"
)

func runScheduler(s *gocron.Scheduler, sChan chan models.AppletStatus) {
	for {
		status := <-sChan
		switch status {
		case models.RUN:
			s.StartAsync()
		case models.PAUSE:
			s.Stop()
		case models.STOP:
			s.Stop()
			close(sChan)
			return
		}
	}
}

// EveryMinute is a function that runs every minute
func EveryMinute(tokenRaw models.Token, reactions []utils.Reaction, userID uint, channel chan models.AppletStatus) {
	s := gocron.NewScheduler(time.UTC)
	s.Every(1).Minute().Do(func() {
		for _, reaction := range reactions {
			serviceName := utils.GetServiceNameFromServiceID(reaction.ServiceID)
			token, _ := utils.GetUserServiceToken(serviceName, userID)
			reaction.Function(token, reaction.Params)
		}
	})

	runScheduler(s, channel)
}

// EveryHour is a function that runs every hour
func EveryHour(tokenRaw models.Token, reactions []utils.Reaction, userID uint, channel chan models.AppletStatus) {
	s := gocron.NewScheduler(time.UTC)
	s.Every(1).Hour().Do(func() {
		log.Println("EveryHour")
		for _, reaction := range reactions {
			serviceName := utils.GetServiceNameFromServiceID(reaction.ServiceID)
			token, _ := utils.GetUserServiceToken(serviceName, userID)
			reaction.Function(token, reaction.Params)
		}
	})
	runScheduler(s, channel)
}

// EveryDay is a function that runs every day
func EveryDay(tokenRaw models.Token, reactions []utils.Reaction, userID uint, channel chan models.AppletStatus) {
	s := gocron.NewScheduler(time.UTC)
	s.Every(1).Day().Do(func() {
		log.Println("EveryDay")
		for _, reaction := range reactions {
			serviceName := utils.GetServiceNameFromServiceID(reaction.ServiceID)
			token, _ := utils.GetUserServiceToken(serviceName, userID)
			reaction.Function(token, reaction.Params)
		}
	})
	runScheduler(s, channel)
}

// EveryWeek is a function that runs every week
func EveryWeek(tokenRaw models.Token, reactions []utils.Reaction, userID uint, channel chan models.AppletStatus) {
	s := gocron.NewScheduler(time.UTC)
	s.Every(1).Week().Do(func() {
		log.Println("EveryWeek")
		for _, reaction := range reactions {
			serviceName := utils.GetServiceNameFromServiceID(reaction.ServiceID)
			token, _ := utils.GetUserServiceToken(serviceName, userID)
			reaction.Function(token, reaction.Params)
		}
	})
	runScheduler(s, channel)
}

// EveryMonth is a function that runs every month
func EveryMonth(tokenRaw models.Token, reactions []utils.Reaction, userID uint, channel chan models.AppletStatus) {
	s := gocron.NewScheduler(time.UTC)
	s.Every(1).Month().Do(func() {
		log.Println("EveryMonth")
		for _, reaction := range reactions {
			serviceName := utils.GetServiceNameFromServiceID(reaction.ServiceID)
			token, _ := utils.GetUserServiceToken(serviceName, userID)
			reaction.Function(token, reaction.Params)
		}
	})
	runScheduler(s, channel)
}
