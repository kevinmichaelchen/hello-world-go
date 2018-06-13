# hello-world-go
[![GoDoc](https://godoc.org/github.com/kevinmichaelchen/hello-world-go?status.svg)](https://godoc.org/github.com/kevinmichaelchen/hello-world-go)
[![Go report](http://goreportcard.com/badge/kevinmichaelchen/hello-world-go)](http://goreportcard.com/report/kevinmichaelchen/hello-world-go)

A simple Go server that demos routing.

## Running Locally

```bash
# Build and start server
make

# Hit endpoint
curl http://localhost:7899/id
```

## Running with Docker-Compose
```bash
make docker-build
docker-compose up -d
curl http://localhost:7899/id
docker-compose stop
```

## Running in Minikube
Install Docker ([for Mac](https://docs.docker.com/docker-for-mac/install/), [for Windows](https://docs.docker.com/docker-for-windows/install/)), 
[hyperkit](https://github.com/kubernetes/minikube/blob/master/docs/drivers.md#hyperkit-driver), and 
[minikube](https://github.com/kubernetes/minikube#installation).

Sometimes I have to `minikube stop; minikube delete; rm -rf ~/.minikube; brew cask reinstall minikube`.

### Minikube load balancing demo
Here's a quick demo of load balancing in minikube
```bash
# Start the cluster. Takes a minute. Be patient.
make mk-start

# Build the Docker image, start your K8S services + deployments
make mk-build kb-create

# Wait for your pods to start
# kubectl get svc,deploy,po
kubectl get --watch po

# Hit the endpoint multiple times and observe load balancing in action
for i in $(seq 1 7); do printf "Request #$i: "; curl $(minikube service hello-world-go-api --url)/id; echo ""; done
```
