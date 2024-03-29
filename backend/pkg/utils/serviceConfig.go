package utils

import (
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/endpoints"
)

type ServiceConfig struct {
	EnvPrefix string          `json:"env_prefix"`
	Endpoint  oauth2.Endpoint `json:"endpoint"`
}

var (
	googleConfig ServiceConfig = ServiceConfig{
		"GOOGLE", endpoints.Google,
	}

	ServiceConfigs map[string]ServiceConfig = map[string]ServiceConfig{
		"Google Contacts": googleConfig,
		"Gmail":           googleConfig,
		"Youtube":         googleConfig,
		"Google Calendar": googleConfig,
		"Google Drive":    googleConfig,
		"Google Docs":     googleConfig,
		"Google Forms":    googleConfig,
	}
)
