package utils

import (
	"fmt"
	"log"
	"math/rand"
	"regexp"
	"strings"
	"time"

	"area/pkg/models"
)

func GetServiceNameFromServiceID(id uint) string {
	var service models.Service
	models.DB.Where("id = ?", id).Find(&service)
	return service.Name
}

func isDateAndTime(datetime string) bool {
	// date+time format : 2006-01-02T15:04:05-07:00
	re := regexp.MustCompile("\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}-\\d{2}:\\d{2}")

	return re.MatchString(datetime)
}

func isTime(time string) bool {
	// time format : 15:04
	re := regexp.MustCompile("\\d{2}:\\d{2}")

	return re.MatchString(time)
}

func GetUserIDByEmail(email string) uint {
	var Token models.Token
	models.DB.Where("associated_email_address = ?", email).Find(&Token)
	return Token.UserID
}

func IsAppletActive(id uint) bool {
	var applet models.Applet
	models.DB.Where("id = ?", id).Find(&applet)
	if applet.RunningStatus == models.RUN {
		return true
	}
	return false
}

func SplitStringsByComma(str string) []string {
	array := strings.Split(str, ",")

	for i, e := range array {
		array[i] = strings.Trim(e, " ")
	}
	return array
}

func ParamsToMap(params string) map[string]string {
	newParams := make(map[string]string)
	firstCut := strings.Split(params, "|")
	for _, param := range firstCut {
		if param == "" {
			return newParams
		}
		if strings.Contains(param, "http://") || strings.Contains(param, "https://") {
			secondCut := strings.SplitN(param, ":", 2)
			newParams[secondCut[0]] = secondCut[1]
		} else if isDateAndTime(param) {
			secondCut := strings.SplitN(param, ":", 4)
			newParams[secondCut[0]] = secondCut[1]
		} else if isTime(param) {
			secondCut := strings.SplitN(param, ":", 2)
			newParams[secondCut[0]] = secondCut[1]
		} else {
			secondCut := strings.Split(param, ":")
			newParams[secondCut[0]] = secondCut[1]
		}
	}
	return newParams
}

func GenerateRandomString(size int) string {
	var letters = []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
	b := make([]rune, size)
	for i := range b {
		b[i] = letters[rand.Intn(len(letters))]
	}
	return string(b)
}

func GetEmailFromUserID(userID uint) string {
	var user models.User
	models.DB.Where("id = ?", userID).Find(&user)
	return user.Email
}

func ConvertHTMLTimeToDuration(timeString string) time.Duration {
	log.Println("timeString:", timeString)
	durationString := fmt.Sprintf("%sh%sm", timeString[:2], timeString[3:5])
	duration, err := time.ParseDuration(durationString)
	if err != nil {
		return time.Hour * 0
	}
	return duration
}
