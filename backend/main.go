package main

import (
	"crud/crud/config"
	"crud/crud/controllers"
	"log"
	"net/http"
	"os"

	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
	"github.com/joho/godotenv"
)

func main() {
	config.InitDB()
	r := mux.NewRouter()
	err := godotenv.Load("./.env")
	if err != nil {
		log.Fatalf("Error Loading .env file: %v", err)
	}
	Port := os.Getenv("PORT")

	corsOptions := handlers.CORS(
		handlers.AllowedOrigins([]string{"*"}),
		handlers.AllowedMethods([]string{"GET", "POST", "PUT", "DELETE", "OPTIONS"}),
		handlers.AllowedHeaders([]string{"Content-Type", "Authorization"}),
		handlers.AllowCredentials(),
		handlers.MaxAge(3600),
	)

	r.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello World"))
	})

	r.HandleFunc("/api/products", controllers.GetProducts).Methods("GET")
	r.HandleFunc("/api/products/{id}", controllers.GetProductById).Methods("GET")
	r.HandleFunc("/api/products", controllers.AddProduct).Methods("POST", "OPTIONS")
	r.HandleFunc("/api/products/{id}", controllers.UpdateProductById).Methods("PUT", "OPTIONS")
	r.HandleFunc("/api/products/{id}", controllers.DeleteProductById).Methods("DELETE", "OPTIONS")

	http.Handle("/", corsOptions(r))
	http.ListenAndServe(":"+Port, nil)

}
