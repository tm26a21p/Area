package main

import (
	"log"
	"math/rand"
	"os"
	"sync"
	"time"

	"area/pkg/manager"
	"area/pkg/models"
	"area/pkg/router"
	"area/pkg/utils"

	"github.com/joho/godotenv"
)

/*

	1. goroutine on the API // OK
	2. goroutine on the manager // OK

	3. the manager gets all applets with a status of true // OK
	4. for each applet, it runs a go routine listening on the trigger

*/

func api() {
	r, err := router.New()

	if err != nil {
		log.Printf("Error at Gin Router setup: %s\n", err.Error())
		return
	}

	if err := r.Run(":" + os.Getenv("SERVER_PORT")); err != nil {
		log.Printf("Error at Gin Router running: %s\n", err.Error())
		return
	}
}

func runAll() {
	var wg sync.WaitGroup

	wg.Add(2)

	go func() {
		defer wg.Done()
		api()
	}()

	go func() {
		defer wg.Done()
		manager.Run(utils.PacketChannel)
	}()

	wg.Wait()
}

func main() {
	rand.Seed(time.Now().Unix())

	if err := godotenv.Load(); err != nil {
		log.Printf("Error at .env loading: %s\n", err.Error())
		return
	}
	if err := models.ConnectToDB(); err != nil {
		log.Printf("Error at DB connection: %s\n", err.Error())
		return
	}
	runAll()
}
