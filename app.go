package main

import (
	"fmt"
	"github.com/google/uuid"
	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
	"github.com/kevinmichaelchen/my-go-utils"
	"log"
	"net/http"
)

type App struct {
	Router *mux.Router
	ID     uuid.UUID
}

func (a *App) Initialize() {
	a.ID = uuid.Must(uuid.NewRandom())
	a.initializeRoutes()
}

func (a *App) initializeRoutes() {
	a.Router = mux.NewRouter()
	a.Router.HandleFunc("/id", a.GetAppID).Methods("GET")
}

func (a *App) ServeRest(addr string) {
	headersOk := handlers.AllowedHeaders([]string{"X-Requested-With", "Content-Type"})
	originsOk := handlers.AllowedOrigins([]string{"http://localhost:3000"})
	methodsOk := handlers.AllowedMethods([]string{"GET", "HEAD", "DELETE", "POST", "PUT", "OPTIONS"})
	log.Fatal(http.ListenAndServe(addr, handlers.CORS(originsOk, headersOk, methodsOk)(a.Router)))
}

func (a *App) GetAppID(w http.ResponseWriter, r *http.Request) {
	log.Println("Someone is requesting our app ID...")
	utils.RespondWithMessage(w, http.StatusOK, fmt.Sprintf("Your App ID is: %s", a.ID))
}
