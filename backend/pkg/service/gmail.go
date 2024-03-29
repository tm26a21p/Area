package service

import (
	"area/pkg/models"
	"area/pkg/utils"
	"context"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/endpoints"
	"google.golang.org/api/gmail/v1"
	"google.golang.org/api/option"
)

func getMailsOAuth2Config() *oauth2.Config {
	return &oauth2.Config{
		ClientID:     os.Getenv("GOOGLE_CLIENT_ID"),
		ClientSecret: os.Getenv("GOOGLE_CLIENT_SECRET"),
		RedirectURL:  "postmessage",
		Scopes:       []string{"https://mail.google.com/"},
		Endpoint:     endpoints.Google,
	}
}

func GetUserMails(token *oauth2.Token, params string) {
	mailsConfig := getMailsOAuth2Config()
	tokenSource := mailsConfig.TokenSource(context.Background(), token)
	srv, err := gmail.NewService(context.Background(), option.WithTokenSource(tokenSource))
	var mailList []string = []string{}

	if err != nil {
		log.Println(err)
		return
	}

	r, err := srv.Users.Messages.List("me").Do()
	if err != nil {
		log.Println(err)
		return
	}

	if len(r.Messages) > 0 {
		for _, c := range r.Messages {
			mailList = append(mailList, c.Id)
		}
	}

	if len(mailList) <= 0 {
		log.Println("no mails found")
		return
	} else {
		log.Println("Mails List:")
		for i, e := range mailList {
			log.Printf("%d. %s\n", i, e)
		}
	}
}

func generateGoogleMessage(to string, subject string, body string) gmail.Message {
	var message gmail.Message
	dt := time.Now().Format(time.RFC1123Z)
	messageID := utils.GenerateRandomString(32)

	msgString := fmt.Sprintf("From: \r\nTo: %s\r\nSubject: %s\r\nDate: %s\r\nMessage-ID: %s\r\n\r\n%s\r\n", to, subject, dt, messageID, body)
	message.Raw = base64.URLEncoding.EncodeToString([]byte(msgString))
	message.Id = messageID
	return message
}

func SendGoogleEmail(tokenRaw models.Token, params string) {
	token := &tokenRaw.AccessToken
	mailsConfig := getMailsOAuth2Config()
	tokenSource := mailsConfig.TokenSource(context.Background(), token)
	srv, err := gmail.NewService(context.Background(), option.WithTokenSource(tokenSource))

	if err != nil {
		log.Println(err)
		return
	}

	newParams := utils.ParamsToMap(params)
	message := generateGoogleMessage(newParams["to"], newParams["subject"], newParams["body"])

	_, err = srv.Users.Messages.Send("me", &message).Do()
	if err != nil {
		log.Println("error send Google email : ", err)
		return
	}
}

func SendGoogleEmailToYourself(tokenRaw models.Token, params string) {
	token := &tokenRaw.AccessToken
	mailsConfig := getMailsOAuth2Config()
	tokenSource := mailsConfig.TokenSource(context.Background(), token)
	srv, err := gmail.NewService(context.Background(), option.WithTokenSource(tokenSource))

	if err != nil {
		log.Println(err)
		return
	}

	newParams := utils.ParamsToMap(params)
	userAddress := utils.GetEmailFromUserID(tokenRaw.UserID)
	message := generateGoogleMessage(userAddress, newParams["subject"], newParams["body"])

	_, err = srv.Users.Messages.Send("me", &message).Do()
	if err != nil {
		log.Println("error send Google email : ", err)
		return
	}
}

func GmailEmptyTrash(tokenRaw models.Token, params string) {
	token := &tokenRaw.AccessToken
	mailsConfig := getMailsOAuth2Config()
	tokenSource := mailsConfig.TokenSource(context.Background(), token)
	srv, err := gmail.NewService(context.Background(), option.WithTokenSource(tokenSource))

	if err != nil {
		log.Println(err)
		return
	}
	// get all messages in trash
	r, err := srv.Users.Messages.List("me").Q("in:trash").Do()
	if err != nil {
		log.Println(err)
		return
	}
	// delete all messages in trash
	for _, c := range r.Messages {
		// print title of message
		_ = srv.Users.Messages.Delete("me", c.Id).Do()
		log.Println("Deleted message with id: ", c.Id)
	}
}

type GooglePubSubMessage struct {
	Message struct {
		Data        string `json:"data"`
		ID          string `json:"messageId"`
		PublishTime string `json:"publishTime"`
	} `json:"message"`
	Subscription string `json:"subscription"`
}

type Data struct {
	Email     string `json:"emailAddress"`
	HistoryID uint   `json:"historyId"`
}

type GmailWebHookRaw struct {
	UserID    uint
	AppletID  uint
	tokenRaw  models.Token
	Reactions []utils.Reaction
}

var GmailWebhookStore []GmailWebHookRaw

func ProcessGmailWebhook(email string) {
	userID := utils.GetUserIDByEmail(email)
	for _, e := range GmailWebhookStore {
		if e.UserID == userID && utils.IsAppletActive(e.AppletID) {
			for _, reaction := range e.Reactions {
				log.Println("Gmail Webhook triggers : ", reaction.Name)
				reaction.Function(e.tokenRaw, reaction.Params)
			}
		}
	}
}

func GmailWebhook(c *gin.Context) {
	var webhook GooglePubSubMessage
	err := c.BindJSON(&webhook)
	if err != nil {
		log.Println(err)
		return
	}
	c.Writer.WriteHeader(http.StatusOK)
	message, err := base64.StdEncoding.DecodeString(webhook.Message.Data)
	if err != nil {
		log.Println(err)
		return
	}
	var data Data
	err = json.Unmarshal(message, &data)
	if err != nil {
		log.Println(" error unmarshal : ", err)
		return
	}
	ProcessGmailWebhook(data.Email)
}

func ReceiveGoogleEmail(tokenRaw models.Token, reactions []utils.Reaction, userID uint, channel chan models.AppletStatus) {
	token := &tokenRaw.AccessToken
	mailsConfig := getMailsOAuth2Config()
	tokenSource := mailsConfig.TokenSource(context.Background(), token)
	srv, err := gmail.NewService(context.Background(), option.WithTokenSource(tokenSource))

	if err != nil {
		log.Println(err)
		return
	}

	// watch for new emails
	watchRequest := gmail.WatchRequest{
		LabelIds:  []string{"INBOX"},
		TopicName: "projects/area-366909/topics/area",
	}

	_, err = srv.Users.Watch("me", &watchRequest).Do()
	if err != nil {
		log.Println(err)
		return
	}
	var raw = GmailWebHookRaw{
		UserID:    userID,
		AppletID:  reactions[0].AppletID,
		tokenRaw:  tokenRaw,
		Reactions: reactions,
	}
	GmailWebhookStore = append(GmailWebhookStore, raw)
	log.Println("Added gmail webhook for user : ", userID)
}
