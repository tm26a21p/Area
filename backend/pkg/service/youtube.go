package service

import (
	"area/pkg/models"
	"area/pkg/utils"
	"context"
	"log"
	"os"
	"strings"

	"golang.org/x/oauth2"
	"golang.org/x/oauth2/endpoints"
	"google.golang.org/api/option"
	"google.golang.org/api/youtube/v3"
)

func getYoutubeOAuth2Config() *oauth2.Config {
	return &oauth2.Config{
		ClientID:     os.Getenv("GOOGLE_CLIENT_ID"),
		ClientSecret: os.Getenv("GOOGLE_CLIENT_SECRET"),
		RedirectURL:  "postmessage",
		Scopes:       []string{"https://www.googleapis.com/auth/youtube.force-ssl"},
		Endpoint:     endpoints.Google,
	}
}

func CommentYoutubeVideo(tokenRaw models.Token, params string) {
	token := &tokenRaw.AccessToken
	youtubeConfig := getYoutubeOAuth2Config()
	tokenSource := youtubeConfig.TokenSource(context.Background(), token)
	srv, err := youtube.NewService(context.Background(), option.WithTokenSource(tokenSource))

	if err != nil {
		log.Println(err)
		return
	}
	newParams := utils.ParamsToMap(params)
	comment := newParams["comment"]
	videoUrl := newParams["videoUrl"]
	videoId := strings.Split(videoUrl, "v=")[1]
	call := srv.CommentThreads.Insert([]string{"snippet"}, &youtube.CommentThread{
		Snippet: &youtube.CommentThreadSnippet{
			VideoId: videoId,
			TopLevelComment: &youtube.Comment{
				Snippet: &youtube.CommentSnippet{
					TextOriginal: comment,
				},
			},
		},
	})
	_, err = call.Do()
	if err != nil {
		log.Println(err)
		return
	}
}

func LikeYoutubeVideo(tokenRaw models.Token, params string) {
	token := &tokenRaw.AccessToken
	youtubeConfig := getYoutubeOAuth2Config()
	tokenSource := youtubeConfig.TokenSource(context.Background(), token)
	srv, err := youtube.NewService(context.Background(), option.WithTokenSource(tokenSource))

	if err != nil {
		log.Println(err)
		return
	}
	newParams := utils.ParamsToMap(params)
	videoUrl := newParams["videoUrl"]
	videoId := strings.Split(videoUrl, "v=")[1]
	call := srv.Videos.Rate(videoId, "like")
	response := call.Do()
	log.Println(response)
}

func DislikeYoutubeVideo(tokenRaw models.Token, params string) {
	token := &tokenRaw.AccessToken
	youtubeConfig := getYoutubeOAuth2Config()
	tokenSource := youtubeConfig.TokenSource(context.Background(), token)
	srv, err := youtube.NewService(context.Background(), option.WithTokenSource(tokenSource))

	if err != nil {
		log.Println(err)
		return
	}
	newParams := utils.ParamsToMap(params)
	videoUrl := newParams["videoUrl"]
	videoId := strings.Split(videoUrl, "v=")[1]
	call := srv.Videos.Rate(videoId, "dislike")
	call.Do()
}

func SubscribeYoutubeChannel(tokenRaw models.Token, params string) {
	token := &tokenRaw.AccessToken
	youtubeConfig := getYoutubeOAuth2Config()
	tokenSource := youtubeConfig.TokenSource(context.Background(), token)
	srv, err := youtube.NewService(context.Background(), option.WithTokenSource(tokenSource))

	if err != nil {
		log.Println(err)
		return
	}
	newParams := utils.ParamsToMap(params)
	channelUrl := newParams["channelUrl"]
	channelId := strings.Split(channelUrl, "channel/")[1]
	call := srv.Subscriptions.Insert([]string{"snippet"}, &youtube.Subscription{
		Snippet: &youtube.SubscriptionSnippet{
			ResourceId: &youtube.ResourceId{
				ChannelId: channelId,
			},
		},
	})
	_, err = call.Do()
	if err != nil {
		log.Println(err)
		return
	}
}
