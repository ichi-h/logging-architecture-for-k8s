package main

import (
	"encoding/json"
	"fmt"
	"math/rand"
	"os"
	"time"
)

func main() {
	interval := getInterval(1)
	rand.Seed(time.Now().UnixNano())
	for {
		logType := getLogType()
		switch logType {
		case "INFO":
			log := map[string]interface{}{
				"timestamp": time.Now().UTC().Format(time.RFC3339),
				"loglevel": "INFO",
				"message": "Request handled",
				"request_id": randomID(),
				"method": "POST",
				"path": "/api/v1/resource",
				"remote_addr": "192.168.1.1",
				"request_headers": map[string]string{
					"Content-Type": "application/json",
				},
				"request_body": "{\"name\": \"test\", \"value\": 123}",
				"response_status": 200,
				"response_headers": map[string]string{
					"Content-Type": "application/json",
				},
				"response_body": "{\"result\": \"ok\"}",
				"elapsed_ms": rand.Intn(100),
				"extra": map[string]string{
					"user_id": "user123",
					"session_id": "session456",
				},
			}
			outputLog(log)
		case "DEBUG":
			log := map[string]interface{}{
				"timestamp": time.Now().UTC().Format(time.RFC3339),
				"loglevel": "DEBUG",
				"message": "External API authentication successful",
				"extra": map[string]string{
					"user_id": "user123",
					"session_id": "session456",
				},
			}
			outputLog(log)
		case "ERROR":
			log := map[string]interface{}{
				"timestamp": time.Now().UTC().Format(time.RFC3339),
				"loglevel": "ERROR",
				"message": "Failed to connect to database",
				"trace_id": randomID(),
				"error": map[string]interface{}{
					"code": "DB_CONN_ERR",
					"message": "Could not connect to the database at db.example.com:5432",
					"stack_trace": []string{
						"main.go:42: connectDB()",
						"main.go:58: handleRequest()",
						"main.go:75: main()",
					},
				},
				"method": "POST",
				"path": "/api/v1/resource",
				"remote_addr": "192.168.1.1",
				"request_headers": map[string]string{
					"Content-Type": "application/json",
				},
				"request_body": "{\"name\": \"test\", \"value\": 123}",
				"response_status": 500,
				"response_headers": map[string]string{
					"Content-Type": "application/json",
				},
				"response_body": "{\"result\": \"error\", \"message\": \"Internal Server Error\"}",
				"elapsed_ms": rand.Intn(100),
				"extra": map[string]string{
					"user_id": "user123",
					"session_id": "session456",
				},
			}
			outputLog(log)
		}
		time.Sleep(interval)
	}
}

func getInterval(sec int) time.Duration {
	if len(os.Args) > 1 {
		if v, err := time.ParseDuration(os.Args[1] + "s"); err == nil {
			sec = int(v.Seconds())
		}
	}
	return time.Duration(sec) * time.Second
}

func getLogType() string {
	r := rand.Intn(100)
	if r < 90 {
		return "INFO"
	} else if r < 95 {
		return "DEBUG"
	}
	return "ERROR"
}

func randomID() string {
	letters := []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
	b := make([]rune, 8)
	for i := range b {
		b[i] = letters[rand.Intn(len(letters))]
	}
	return string(b)
}

func outputLog(log map[string]interface{}) {
	b, err := json.Marshal(log)
	if err != nil {
		fmt.Fprintf(os.Stderr, "failed to marshal log: %v\n", err)
		return
	}
	fmt.Println(string(b))
}
