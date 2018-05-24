FROM golang:1.10 as builder
ADD . /go/src/github.com/kevinmichaelchen/hello-world-go
WORKDIR /go/src/github.com/kevinmichaelchen/hello-world-go
RUN go get ./... && \
    CGO_ENABLED=0 GOOS=linux go build -a -o ./bin/hello-world-go .

FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /root/
COPY --from=builder /go/src/github.com/kevinmichaelchen/hello-world-go/bin/hello-world-go .

CMD ["./hello-world-go"]