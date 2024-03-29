package service

import (
	"area/pkg/models"
	"area/pkg/utils"
	"context"
	"log"
	"os"

	"golang.org/x/oauth2"
	"golang.org/x/oauth2/endpoints"
	"google.golang.org/api/docs/v1"
	"google.golang.org/api/option"
)

func getDocsOAuth2Config() *oauth2.Config {
	return &oauth2.Config{
		ClientID:     os.Getenv("GOOGLE_CLIENT_ID"),
		ClientSecret: os.Getenv("GOOGLE_CLIENT_SECRET"),
		RedirectURL:  "postmessage",
		Scopes:       []string{"https://www.googleapis.com/auth/documents"},
		Endpoint:     endpoints.Google,
	}
}

func CreateGoogleDocsDocument(tokenRaw models.Token, params string) {
	docsConfig := getDocsOAuth2Config()
	token := &tokenRaw.AccessToken
	tokenSource := docsConfig.TokenSource(context.Background(), token)
	srv, err := docs.NewService(context.Background(), option.WithTokenSource(tokenSource))

	if err != nil {
		log.Println(err)
		return
	}
	newParams := utils.ParamsToMap(params)
	title := newParams["title"]
	body := newParams["body"]
	log.Println("title: ", title+" body: ", body)
	doc, err := srv.Documents.Create(&docs.Document{
		Title: title,
		Body: &docs.Body{
			Content: []*docs.StructuralElement{
				{
					Paragraph: &docs.Paragraph{
						Elements: []*docs.ParagraphElement{
							{
								TextRun: &docs.TextRun{
									Content: body,
								},
							},
						},
					},
				},
			},
		},
	}).Do()
	if err != nil {
		log.Println(err)
		return
	}
	log.Println("Created document with ID: ", doc.DocumentId)
}
