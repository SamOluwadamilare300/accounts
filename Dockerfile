# Build stage
FROM golang:1.25-alpine AS builder

WORKDIR /go/src/github.com/moov-io/accounts

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64
ENV GONOSUMDB=*
ENV DEFAULT_ROUTING_NUMBER=221475786

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -o /bin/server ./cmd/server/

# Final stage
FROM alpine:3.19

RUN apk --no-cache add ca-certificates tzdata

WORKDIR /app

COPY --from=builder /bin/server /bin/server

EXPOSE 8085 9095

ENV DEFAULT_ROUTING_NUMBER=221475786

ENTRYPOINT ["/bin/server"]