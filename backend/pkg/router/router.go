package router

import (
	"area/pkg/controllers"
	"area/pkg/middlewares"
	"area/pkg/service"
	"area/pkg/utils"

	"github.com/gin-gonic/gin"
)

func New() (*gin.Engine, error) {
	r := gin.New()
	r.ForwardedByClientIP = true
	if e := r.SetTrustedProxies([]string{"127.0.0.1"}) ; e != nil {
		return nil, e
	}

	r.Use(middlewares.GetCorsHandler())

	r.GET("/users", controllers.GetUsers)
	r.POST("/users", controllers.CreateUser) // this route will be deleted soon due to security reasons
	r.GET("/users/:id", controllers.GetUser)
	r.PATCH("/users/:id", controllers.UpdateUser)
	r.DELETE("/users/:id", controllers.DeleteUser)

	// basic auth routes
	r.POST("register", controllers.Register)
	r.POST("login", controllers.Login)
	// r.GET("profile", controllers.Profile)
	r.POST("/logout", controllers.Logout)
	// basic service routes
	r.GET("/services", controllers.GetServices)
	r.POST("/services", controllers.CreateService)
	r.GET("/services/:id", controllers.GetService)
	r.PATCH("/services/:id", controllers.UpdateService)
	r.DELETE("/services/:id", controllers.DeleteService)

	// basic area routes
	r.GET("/areas", controllers.GetAreas)
	r.GET("/actions", controllers.GetActions)
	r.GET("/reactions", controllers.GetReactions)
	r.GET("/actions/:service_id", controllers.GetActionsByServiceID)
	r.GET("/reactions/:service_id", controllers.GetReactionsByServiceID)
	r.POST("/area", controllers.CreateTemplateArea)
	r.PATCH("/area/:id", controllers.UpdateTemplateArea)
	r.DELETE("/area/:id", controllers.DeleteTemplateArea)

	// basic applet routes
	r.GET("/applets/:id", controllers.GetAppletsByUserID)
	r.GET("/applet/:id", controllers.GetAppletAloneByUserID)
	r.POST("/applet/:id", controllers.CreateApplet)
	r.PUT("/applet/:id", controllers.UpdateApplet)
	r.PUT("applet/toggle/:id", controllers.ToggleApplet)
	r.DELETE("/applet/:id", controllers.DeleteApplet)

	// basic token routes
	r.GET("/tokens", controllers.GetTokensHandler)

	r.GET("/tokens/:service_name/:user_id", controllers.IsUserConnectedToServiceHandler)

	// OAuth2 routes
	r.POST("/connect/:user_id", controllers.ConnectToServiceHandler)
	// r.POST("/deconnect/:user_id", middlewares.IsUserConnectedToService(), controllers.DeconnectToServiceHandler)

	// google routes
	r.POST("/google/login", controllers.GoogleLogin)
	r.POST("/google/login/native", controllers.NativeGoogleLogin)

	// about.json route
	r.GET("/about.json", utils.About)

	// webhooks routes
	r.POST("/gmail/webhook", service.GmailWebhook)
	return r, nil
}
