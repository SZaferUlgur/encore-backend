package controllers

import (
	"crud/crud/config"
	"crud/crud/models"
	"encoding/json"
	"io"
	"net/http"

	"github.com/gorilla/mux"
)

func AddProduct(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	body, err := io.ReadAll(r.Body)
	if err != nil {
		http.Error(w, "Failed to read request Body", http.StatusBadRequest)
		return
	}
	var product models.Product
	if err := json.Unmarshal(body, &product); err != nil {
		http.Error(w, "Failed to parse request Body", http.StatusBadRequest)
		return
	}
	db := config.DB
	var result string

	err = db.QueryRow("CALL addProductSP (?, ?, ?,?)", product.UrunAdi, product.Fiyat,
		product.Miktar, product.ImageUrl).Scan(&result)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.Write([]byte(result))
}

func DeleteProductById(w http.ResponseWriter, r *http.Request) {
	if r.Method != "DELETE" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	vars := mux.Vars(r)
	id := vars["id"]

	if id == "" {
		http.Error(w, "Missing id parameter", http.StatusBadRequest)
		return
	}
	db := config.DB
	var result string
	err := db.QueryRow("CALL deleteProductByIdSP (?)", id).Scan(&result)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.Write([]byte(result))
}

func GetProductById(w http.ResponseWriter, r *http.Request) {
	if r.Method != "GET" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	vars := mux.Vars(r)
	id := vars["id"]
	if id == "" {
		http.Error(w, "Missing id parameter", http.StatusBadRequest)
		return
	}
	db := config.DB
	var result string
	err := db.QueryRow("CALL getProductByIdSP (?)", id).Scan(&result)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.Write([]byte(result))
}

func GetProducts(w http.ResponseWriter, r *http.Request) {
	if r.Method != "GET" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	db := config.DB
	row := db.QueryRow("CALL getAllProductsSP()")
	var result string
	err := row.Scan(&result)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.Write([]byte(result))
}

func UpdateProductById(w http.ResponseWriter, r *http.Request) {
	if r.Method != "PUT" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	vars := mux.Vars(r)
	id := vars["id"]
	if id == "" {
		http.Error(w, "Missing id parameter", http.StatusBadRequest)
		return
	}
	body, err := io.ReadAll(r.Body)
	if err != nil {
		http.Error(w, "Failed to read request Body", http.StatusBadRequest)
		return
	}
	var product models.Product
	if err := json.Unmarshal(body, &product); err != nil {
		http.Error(w, "Failed to parse request Body", http.StatusBadRequest)
		return
	}
	db := config.DB
	var result string
	err = db.QueryRow("CALL updateProductByIdSP (?, ?, ?, ?, ?)", id, product.UrunAdi, product.Fiyat,
		product.Miktar, product.ImageUrl).Scan(&result)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.Write([]byte(result))
}
