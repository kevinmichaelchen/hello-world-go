package main

import (
	"fmt"
	"log"
	"os"
	"strconv"
	"sync"
)

func main() {

	portString, ok := os.LookupEnv("APP_PORT")
	if !ok {
		portString = "7899"
	}
	port, err := strconv.Atoi(portString)
	if err != nil {
		log.Fatalf("port is invalid: %s", portString)
	}

	var wg sync.WaitGroup

	a := App{}
	a.Initialize()

	wg.Add(1)
	go a.ServeRest(fmt.Sprintf(":%d", port))

	wg.Wait()
}
