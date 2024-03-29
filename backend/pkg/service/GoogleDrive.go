package service

import (
	"area/pkg/models"
	"context"
	"log"
	"os"

	"golang.org/x/oauth2"
	"golang.org/x/oauth2/endpoints"
	"google.golang.org/api/drive/v3"
	"google.golang.org/api/option"
)

func getDriveOAuth2Config() *oauth2.Config {
	return &oauth2.Config{
		ClientID:     os.Getenv("GOOGLE_CLIENT_ID"),
		ClientSecret: os.Getenv("GOOGLE_CLIENT_SECRET"),
		RedirectURL:  "postmessage",
		Scopes:       []string{"https://www.googleapis.com/auth/docs"},
		Endpoint:     endpoints.Google,
	}
}

func GetUserDrive(token *oauth2.Token, params string) {
	driveConfig := getDriveOAuth2Config()
	tokenSource := driveConfig.TokenSource(context.Background(), token)
	srv, err := drive.NewService(context.Background(), option.WithTokenSource(tokenSource))
	var driveList []string = []string{}

	if err != nil {
		log.Println(err)
		return
	}

	r, err := srv.Files.List().Do()
	if err != nil {
		log.Println(err)
		return
	}

	if len(r.Files) > 0 {
		for _, c := range r.Files {
			driveList = append(driveList, c.Id)
		}
	}

	if len(driveList) <= 0 {
		log.Println("no files found")
		return
	} else {
		log.Println("Files List:")
		for i, e := range driveList {
			log.Println(i, e)
		}
	}
}

func EmptyTrashGoogleDrive(tokenRaw models.Token, params string) {
	driveConfig := getDocsOAuth2Config()
	token := &tokenRaw.AccessToken
	tokenSource := driveConfig.TokenSource(context.Background(), token)
	srv, err := drive.NewService(context.Background(), option.WithTokenSource(tokenSource))
	if err != nil {
		log.Println(err)
		return
	}

	err = srv.Files.EmptyTrash().Do()
	if err != nil {
		log.Println(err)
		return
	}
}
