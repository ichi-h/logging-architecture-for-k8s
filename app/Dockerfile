FROM golang:1.25.0-alpine3.22 AS builder
WORKDIR /app
COPY . .
RUN go build -o demoapp main.go

FROM alpine:3.22
WORKDIR /app
COPY --from=builder /app/demoapp ./demoapp
ENTRYPOINT ["/app/demoapp"]
