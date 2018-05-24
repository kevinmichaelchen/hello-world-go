package main

import (
	"fmt"
	"sync"
	"github.com/TeslaGov/envy"
)

func main() {

	port := envy.IntOr("APP_PORT", 7899)

	var wg sync.WaitGroup

	a := App{}
	a.Initialize()

	wg.Add(1)
	go a.ServeRest(fmt.Sprintf(":%d", port))

	wg.Wait()
}
