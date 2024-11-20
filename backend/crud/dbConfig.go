package config

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	_ "github.com/go-sql-driver/mysql"
	"github.com/joho/godotenv"
)

var DB *sql.DB

func InitDB() {
	err := godotenv.Load("./.env")
	if err != nil {
		log.Fatalf("Error Loading .env file: %v", err)
	}
	dbUser := os.Getenv("DB_USER")
	dbPass := os.Getenv("DB_PASS")
	dbHost := os.Getenv("DB_HOST")
	dbPort := os.Getenv("DB_PORT")
	dbName := os.Getenv("DB_NAME")
	port := os.Getenv("PORT")

	connectionString := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", dbUser, dbPass, dbHost, dbPort, dbName)
	DB, err = sql.Open("mysql", connectionString)
	if err != nil {
		log.Fatalf("Error Connecting to Database: %v", err)
	}
	err = DB.Ping()
	if err != nil {
		log.Fatalf("Error Pinging Database: %v", err)
	}
	log.Printf("Database Connected Successfully Port:%s", port)
}
