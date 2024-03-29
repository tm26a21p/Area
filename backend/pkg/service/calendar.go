package service

import (
	"area/pkg/models"
	"area/pkg/utils"
	"context"
	"errors"
	"fmt"
	"log"
	"os"
	"regexp"

	"strings"
	"time"

	"golang.org/x/oauth2"
	"golang.org/x/oauth2/endpoints"
	"google.golang.org/api/calendar/v3"
	"google.golang.org/api/option"
)

func getCalendarOAuth2Config() *oauth2.Config {
	return &oauth2.Config{
		ClientID:     os.Getenv("GOOGLE_CLIENT_ID"),
		ClientSecret: os.Getenv("GOOGLE_CLIENT_SECRET"),
		RedirectURL:  "postmessage",
		Scopes: []string{
			"https://www.googleapis.com/auth/calendar",
		},
		Endpoint: endpoints.Google,
	}
}

func CreateEvent(tokenRaw models.Token, params string) {
	token := &tokenRaw.AccessToken
	contactsConfig := getContactsOAuth2Config()
	tokenSource := contactsConfig.TokenSource(context.Background(), token)
	srv, err := calendar.NewService(context.Background(), option.WithTokenSource(tokenSource))
	if err != nil {
		log.Println(err)
		return
	}

	newParams := utils.ParamsToMap(params)
	event := calendar.Event{
		Summary:     newParams["summary"],
		Location:    newParams["location"],
		Description: newParams["description"],
		Start: &calendar.EventDateTime{
			DateTime: newParams["start"],
			TimeZone: "Europe/Paris",
		},
		End: &calendar.EventDateTime{
			DateTime: newParams["end"],
			TimeZone: "Europe/Paris",
		},
	}

	_, err = srv.Events.Insert("primary", &event).Do()
	if err != nil {
		log.Println(err)
		return
	}
}

func identifyWhichDays(dayString string) (string, int, error) {
	weekDays := map[string]string{
		"monday": "MO", "tuesday": "TU", "wednesday": "WE", "thursday": "TH",
		"friday": "FR", "saturday": "SA", "sunday": "SU",
	}
	lowerDayString := strings.ToLower(dayString)
	var whichDays string
	currentDay := int(time.Now().Weekday())
	firstDay := -1
	cnt := 0

	for k, v := range weekDays {
		r, _ := regexp.MatchString(k, lowerDayString)

		if r {
			whichDays += v + ","
			if firstDay < 0 {
				firstDay = cnt
			}
		}
		cnt++
	}

	dayMod := firstDay - currentDay
	if currentDay > firstDay {
		dayMod += 6
	}
	if len(whichDays) <= 0 {
		return "", 0, errors.New("no valid day")
	}
	return whichDays[:len(whichDays)-1], dayMod, nil
}

func getStartingAndEndingDateString(startTime string, endTime string, dayMod int) (string, string, error) {
	startHour := utils.ConvertHTMLTimeToDuration(startTime)
	endHour := utils.ConvertHTMLTimeToDuration(endTime)
	startingDate := time.Now().Round(time.Hour*24).Add(startHour).AddDate(0, 0, dayMod)
	endingDate := startingDate.Add(endHour - startHour)

	log.Println("startingDate:", startingDate, "endingDate:", endingDate)
	return startingDate.Format(time.RFC3339), endingDate.Format(time.RFC3339), nil
}

func CreateWeeklyEvent(tokenRaw models.Token, params string) {
	token := &tokenRaw.AccessToken
	contactsConfig := getContactsOAuth2Config()
	tokenSource := contactsConfig.TokenSource(context.Background(), token)
	srv, err := calendar.NewService(context.Background(), option.WithTokenSource(tokenSource))
	if err != nil {
		log.Println(err)
		return
	}

	newParams := utils.ParamsToMap(params)
	whichDays, weekdayMod, err := identifyWhichDays(newParams["which days"])
	if err != nil {
		log.Println(err)
		return
	}

	startingDate, endingDate, err := getStartingAndEndingDateString(newParams["start"], newParams["end"], weekdayMod)
	if err != nil {
		log.Println(err)
		return
	}

	event := calendar.Event{
		Summary:     newParams["summary"],
		Location:    newParams["location"],
		Description: newParams["description"],
		Start: &calendar.EventDateTime{
			DateTime: startingDate,
			TimeZone: "Europe/Paris",
		},
		End: &calendar.EventDateTime{
			DateTime: endingDate,
			TimeZone: "Europe/Paris",
		},
		Recurrence: []string{fmt.Sprintf("RRULE:FREQ=WEEKLY;BYDAY=%s;", whichDays)},
	}

	_, err = srv.Events.Insert("primary", &event).Do()
	if err != nil {
		log.Println(err)
		return
	}
}

func DeleteAllDayEvent(tokenRaw models.Token, params string) {
	token := &tokenRaw.AccessToken
	contactsConfig := getContactsOAuth2Config()
	tokenSource := contactsConfig.TokenSource(context.Background(), token)
	srv, err := calendar.NewService(context.Background(), option.WithTokenSource(tokenSource))
	if err != nil {
		log.Println(err)
		return
	}

	min := time.Now().Round(time.Hour * 24).Add(-time.Hour).AddDate(0, 0, -1).Format(time.RFC3339)
	max := time.Now().Round(time.Hour * 24).Add(-time.Second - time.Hour).Format(time.RFC3339)
	log.Println("min:", min, "max:", max)
	events, err := srv.Events.List("primary").TimeMin(min).TimeMax(max).Do()
	if err != nil {
		log.Println(err)
		return
	}

	for _, event := range events.Items {
		err := srv.Events.Delete("primary", event.Id).Do()
		if err != nil {
			log.Println(err)
			return
		}
	}
}
