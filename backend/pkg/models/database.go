package models

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"os"
	"time"

	"golang.org/x/oauth2"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

// create a map of services path
var servicePath = []string{
	"./pkg/models/config/googleContacts.json",
	"./pkg/models/config/googleMail.json",
	"./pkg/models/config/crontab.json",
	"./pkg/models/config/youtube.json",
	"./pkg/models/config/googleCalendar.json",
	"./pkg/models/config/googleDrive.json",
	"./pkg/models/config/googleDocs.json",
	"./pkg/models/config/googleForms.json",
}

type ServiceJSONInput struct {
	gorm.Model
	Name        string        `json:"name"`
	Description string        `json:"description"`
	Icon        string        `json:"icon"`
	Color       string        `json:"color"`
	Button      ServiceButton `json:"button" gorm:"embedded"`
	Actions     []Area        `json:"actions"`
	Reactions   []Area        `json:"reactions"`
}

// function that read a JSON service and create a new service in the database
func readServiceConfig(path string) ServiceJSONInput {
	// open our jsonFile
	jsonFile, err := os.Open(path)
	// if we os.Open returns an error then handle it
	if err != nil {
		log.Println("couldnt open the file due to : ", err)
	}
	// defer the closing of our jsonFile so that we can parse it later on
	byteValue, _ := io.ReadAll(jsonFile)
	var service ServiceJSONInput
	json.Unmarshal(byteValue, &service)
	defer jsonFile.Close()
	return service
}

func loadServices(db *gorm.DB) {

	for i, path := range servicePath {
		service := readServiceConfig(path)
		ID := uint(i + 1)

		db.Create(&Service{Name: service.Name, Description: service.Description, Icon: service.Icon, Color: service.Color, Button: service.Button})
		for _, action := range service.Actions {
			db.Create(&Area{Name: action.Name, Description: action.Description, IsTemplate: action.IsTemplate,
				IsAction: action.IsAction, FunctionName: action.FunctionName, Config: action.Config, AppletID: 1, ServiceID: ID})
		}
		for _, reaction := range service.Reactions {
			db.Create(&Area{Name: reaction.Name, Description: reaction.Description, IsTemplate: reaction.IsTemplate,
				IsAction: reaction.IsAction, FunctionName: reaction.FunctionName, Config: reaction.Config, AppletID: 1, ServiceID: ID})
		}
	}
}

var (
	mytime                  = time.Date(2022, 11, 9, 21, 44, 16, 429403905, time.UTC)
	john_token oauth2.Token = oauth2.Token{
		AccessToken:  "ya29.a0AeTM1ic72okY0u9lVs3fzWFmGPKv4zCbqDhApcKi94k6vky15fgr30RHWs_9lf2iOFGmpqwrRpiOdssvwQdWHXTHXbH7ajAfMxBoLdzG2S1yDd-gXY3vhHcx7Rd3FLVl74vNfekrgwhgG5Bn_Za2zHACDP6yaCgYKAfESARASFQHWtWOmksXDVyh5woXtTVfaRhkjSg0163",
		TokenType:    "Bearer",
		RefreshToken: "1//03w_v5no1t2mTCgYIARAAGAMSNwF-L9IrkWqI8IkPfeW42NJK9Fv9CHoP9JdToPe7Tu2UngsgQV_SqulFB1PzWz1CHDhkzWAH0Ag",
		Expiry:       mytime,
	}
)

func firstDbInput(db *gorm.DB) {
	db.Create(&User{FirstName: "John", LastName: "Doe", Email: "john.doe@gmail.com", Password: "123456", Avatar: "https://i.pravatar.cc/150?img=1", UUID: "1234567890"})
	db.Create(&Token{ServiceName: "Google Contacts", AccessToken: john_token, UserID: 1})
	db.Create(&Applet{Name: "Applet Template Storing", RunningStatus: STOP, Status: false, UserID: 1})
	loadServices(db)
	// db.Create(&Applet{Name: "Test", RunningStatus: RUN,  Status: true, UserID: 1})
	// db.Create(&Area{Name: "Every minute", Description: "Trigger a workflow every minute", IsTemplate: false, IsAction: true, FunctionName: "EveryMinute", Config: "config", Params: "config", AppletID: 2, ServiceID: 2})
	// db.Create(&Area{Name: "Google Contacts", Description: "Add a contact to your Google Contacts", IsTemplate: false, IsAction: false, FunctionName: "GetUserContacts", Config: "config", AppletID: 2, ServiceID: 1})
}

func firstEverDBinput(db *gorm.DB) {
	// if User John Doe exists, return
	var user User
	db.Where("email = ?", "john.doe@gmail.com").First(&user)
	if user.ID != 0 {
		log.Println("We don't need to input data in the database")
		return
	}
	firstDbInput(db)
}

func ConnectToDB() error {
	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=%s TimeZone=%s",
		os.Getenv("DB_HOST"), os.Getenv("DB_USER"), os.Getenv("DB_PASSWORD"), os.Getenv("DB_NAME"),
		os.Getenv("DB_PORT"), os.Getenv("DB_SSL_MODE"), os.Getenv("DB_TIME_ZONE"))

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})

	if err != nil {
		return err
	}

	db.AutoMigrate(&User{}, &Token{}, &Service{}, &Applet{}, &Area{})
	firstEverDBinput(db)
	DB = db

	return nil
}
