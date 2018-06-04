DOCKER_ORG = kevinmichaelchen

##########################
## BUILDING AND RUNNNIG ##
##########################
.PHONY: all
all:
	@$(MAKE) build
	@$(MAKE) run

.PHONY: build
build:
	go build -o ./bin/hello-world-go .

.PHONY: build-linux
build-linux:
	env GOOS=linux GOARCH=386 go build -o ./bin/hello-world-go-linux -v .

.PHONY: run
run:
	./bin/hello-world-go

.PHONY: fetch-deps
fetch-deps:
	go get -u -v ./...

#####################
### CODE QUALITY  ###
#####################
.PHONY: lint
lint:
	golint .

.PHONY: fmt
fmt:
	go fmt .

.PHONY: vet
vet:
	go tool vet .



#####################
## DOCKER METHODS  ##
#####################
.PHONY: docker-build
docker-build:
	docker image build -t $(DOCKER_ORG)/hello-world-go-api:v0.0.1 .



#####################
## CLUSTER METHODS ##
#####################
.PHONY: mk-build
mk-build:
	@eval $$(minikube docker-env) ;\
	docker image build -t $(DOCKER_ORG)/hello-world-go-api:v0.0.1 .

.PHONY: mk-start
mk-start:
	minikube start --memory 2048 --cpus 2 --vm-driver=hyperkit

.PHONY: mk-stop
mk-stop:
	minikube stop

.PHONY: mk-upgrade
mk-upgrade:
	@$(MAKE) mk-stop
	brew cask reinstall minikube

.PHONY: kb-create
kb-create:
	kubectl create -f ./kube/

.PHONY: kb-delete
kb-delete:
	@kubectl delete svc,deploy --selector="app=hello-world-go"



##################
## CLUSTER PREP ##
##################
.PHONY: install-hyperkit
install-hyperkit:
	curl -LO https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-hyperkit
	chmod +x docker-machine-driver-hyperkit
	sudo mv docker-machine-driver-hyperkit /usr/local/bin/
	sudo chown root:wheel /usr/local/bin/docker-machine-driver-hyperkit
	sudo chmod u+s /usr/local/bin/docker-machine-driver-hyperkit

.PHONY: install-minikube
install-minikube:
	brew cask install minikube