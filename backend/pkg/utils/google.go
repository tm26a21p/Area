package utils

import (
	"context"
	"errors"
	"os"

	"golang.org/x/oauth2"
	"golang.org/x/oauth2/endpoints"
	"google.golang.org/api/option"
	"google.golang.org/api/people/v1"
)

func getContactsOAuth2Config() *oauth2.Config {
	return &oauth2.Config{
		ClientID:     os.Getenv("GOOGLE_CLIENT_ID"),
		ClientSecret: os.Getenv("GOOGLE_CLIENT_SECRET"),
		RedirectURL:  "postmessage",
		Scopes: []string{
			"https://www.googleapis.com/auth/userinfo.profile",
			"https://www.googleapis.com/auth/userinfo.email",
		},
		Endpoint: endpoints.Google,
	}
}

func GetGoogleAssociatedEmailAddress(token *oauth2.Token) (string, error) {
	contactsConfig := getContactsOAuth2Config()
	tokenSource := contactsConfig.TokenSource(context.Background(), token)
	srv, err := people.NewService(context.Background(), option.WithTokenSource(tokenSource))
	if err != nil {
		return "", err
	}

	r, err := srv.People.Get("people/me").PersonFields("emailAddresses").Do()
	if err != nil {
		return "", err
	}

	if len(r.EmailAddresses) <= 0 {
		return "", errors.New("this account doesn't have an associated email address")
	}
	return r.EmailAddresses[0].Value, nil
}
