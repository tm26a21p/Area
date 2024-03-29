package service

import (
	"context"
	"encoding/base64"
	"io/ioutil"
	"log"
	"math/rand"
	"os"

	"area/pkg/models"
	"area/pkg/utils"

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
			"https://www.googleapis.com/auth/contacts",
		},
		Endpoint: endpoints.Google,
	}
}

func GetUserContacts(tokenRaw models.Token, params string) {
	token := &tokenRaw.AccessToken
	contactsConfig := getContactsOAuth2Config()
	tokenSource := contactsConfig.TokenSource(context.Background(), token)
	srv, err := people.NewService(context.Background(), option.WithTokenSource(tokenSource))
	var contactList []string = []string{}

	if err != nil {
		log.Println(err)
		return
	}

	r, err := srv.People.Connections.List("people/me").PersonFields("names,emailAddresses,").Do()
	if err != nil {
		log.Println(err)
		return
	}

	if len(r.Connections) > 0 {
		for _, c := range r.Connections {
			names := c.Names
			if len(names) > 0 {
				name := names[0].DisplayName
				contactList = append(contactList, name)
			}
		}
	}

	if len(contactList) <= 0 {
		log.Println("no contacts found")
		return
	} else {
		log.Println("Contact List:")
		for i, e := range contactList {
			log.Printf("%d. %s\n", i, e)
		}
	}
}

func CreateUserContact(tokenRaw models.Token, params string) {
	token := &tokenRaw.AccessToken
	contactConfig := getContactsOAuth2Config()
	tokenSource := contactConfig.TokenSource(context.Background(), token)
	srv, err := people.NewService(context.Background(), option.WithTokenSource(tokenSource))
	if err != nil {
		log.Println(err)
		return
	}

	newParams := utils.ParamsToMap(params)
	contact := people.Person{
		Names: []*people.Name{
			{
				GivenName:  newParams["givenName"],
				FamilyName: newParams["familyName"],
			},
		},
		EmailAddresses: []*people.EmailAddress{
			{
				Value: newParams["email"],
			},
		},
		PhoneNumbers: []*people.PhoneNumber{
			{
				Value: newParams["phone"],
			},
		},
	}
	_, err = srv.People.CreateContact(&contact).Do()
	if err != nil {
		log.Println(err)
		return
	}
}

func DeleteUserContact(tokenRaw models.Token, params string) {
	token := &tokenRaw.AccessToken
	contactConfig := getContactsOAuth2Config()
	tokenSource := contactConfig.TokenSource(context.Background(), token)
	srv, err := people.NewService(context.Background(), option.WithTokenSource(tokenSource))
	if err != nil {
		log.Println(err)
		return
	}

	newParams := utils.ParamsToMap(params)
	r, err := srv.People.Connections.List("people/me").PersonFields("emailAddresses").Do()
	if err != nil {
		log.Println(err)
		return
	}

	for _, c := range r.Connections {
		if len(c.EmailAddresses) > 0 {
			if c.EmailAddresses[0].Value == newParams["email"] {
				_, err = srv.People.DeleteContact(c.ResourceName).Do()
				if err != nil {
					log.Println(err)
					return
				}
				return
			}
		}
	}

}

func getAllContactRessourceNames(srv *people.Service) ([]string, error) {
	resourceNames := []string{}

	r, err := srv.People.Connections.List("people/me").PersonFields("names").Do()
	if err != nil {
		return nil, err
	}

	for _, c := range r.Connections {
		resourceName := c.ResourceName
		resourceNames = append(resourceNames, resourceName)
	}

	return resourceNames, nil
}

func DropGnomePotion(tokenRaw models.Token, params string) {
	token := &tokenRaw.AccessToken
	contactConfig := getContactsOAuth2Config()
	tokenSource := contactConfig.TokenSource(context.Background(), token)
	srv, err := people.NewService(context.Background(), option.WithTokenSource(tokenSource))
	if err != nil {
		log.Println(err)
		return
	}

	rNames, err := getAllContactRessourceNames(srv)
	if err != nil {
		log.Println(err)
		return
	}

	if len(rNames) > 0 {
		gnomeBytes, err := ioutil.ReadFile("./pkg/service/img/gnome.jpeg")
		if err != nil {
			log.Println(err)
			return
		}

		photoRq := people.UpdateContactPhotoRequest{
			PhotoBytes: base64.StdEncoding.EncodeToString(gnomeBytes),
		}

		gnomedContactRessourceName := rNames[rand.Intn(len(rNames))]

		_, err = srv.People.UpdateContactPhoto(gnomedContactRessourceName, &photoRq).Do()
		if err != nil {
			log.Println(err)
			return
		}
	}
}
