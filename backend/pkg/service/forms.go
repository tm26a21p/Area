package service

import (
	"area/pkg/models"
	"area/pkg/utils"
	"context"
	"log"
	"os"

	"golang.org/x/oauth2"
	"golang.org/x/oauth2/endpoints"
	"google.golang.org/api/forms/v1"
	"google.golang.org/api/option"
)

func getFormsOAuth2Config() *oauth2.Config {
	return &oauth2.Config{
		ClientID:     os.Getenv("GOOGLE_CLIENT_ID"),
		ClientSecret: os.Getenv("GOOGLE_CLIENT_SECRET"),
		RedirectURL:  "postmessage",
		Scopes: []string{
			"https://www.googleapis.com/auth/drive",
		},
		Endpoint: endpoints.Google,
	}
}

func getFormOptionsFromStringArray(optionsStr []string) []*forms.Option {
	options := []*forms.Option{}

	for _, optionStr := range optionsStr {
		option := forms.Option{
			Value: optionStr,
		}
		options = append(options, &option)
	}
	return options
}

func CreateForm(srv *forms.Service, title string) (*forms.Form, error) {
	form := &forms.Form{
		Info: &forms.Info{
			Title:         title,
			DocumentTitle: title,
		},
	}

	form, err := srv.Forms.Create(form).Do()
	if err != nil {
		return nil, err
	}
	return form, nil
}

func GetItemCreationRequest(srv *forms.Service, title string, description string, optionsStr []string) *forms.Request {
	var rq forms.Request
	options := getFormOptionsFromStringArray(optionsStr)

	rq.CreateItem = &forms.CreateItemRequest{
		Item: &forms.Item{
			Title: title,
			Description: description,
			QuestionItem: &forms.QuestionItem{
				Question: &forms.Question{
					ChoiceQuestion: &forms.ChoiceQuestion{
						Options: options,
						Type:    "DROP_DOWN",
					},
				},
			},
		},
		Location: &forms.Location{
			Index: 0,
		},
	}
	return &rq
}

func CreateSimpleForms(tokenRaw models.Token, params string) {
	token := &tokenRaw.AccessToken
	contactsConfig := getContactsOAuth2Config()
	tokenSource := contactsConfig.TokenSource(context.Background(), token)
	srv, err := forms.NewService(context.Background(), option.WithTokenSource(tokenSource))
	if err != nil {
		log.Println(err)
		return
	}

	newParams := utils.ParamsToMap(params)

	form, err := CreateForm(srv, newParams["title"])
	optionsStr := utils.SplitStringsByComma(newParams["answers"])
	rq := GetItemCreationRequest(srv, newParams["title"], newParams["description"], optionsStr)
	updateRq := &forms.BatchUpdateFormRequest{
		Requests: []*forms.Request{
			rq,
		},
	}

	_, err = srv.Forms.BatchUpdate(form.FormId, updateRq).Do()
	if err != nil {
		log.Println(err)
		return
	}
}
