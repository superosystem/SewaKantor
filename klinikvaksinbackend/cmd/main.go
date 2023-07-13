package main

import (
	"os"

	"github.com/superosystem/KlinikVaksin/klinikvaksinbackend/internal/app"
)

func main() {
	route := app.Server()
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	routePort := ":" + port

	route.Logger.Fatal(route.Start(routePort))
}