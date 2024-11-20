package models

import (
	"github.com/shopspring/decimal"
)

type Product struct {
	ID       int             `json:"id"`
	UrunAdi  string          `json:"urunAdi"`
	Fiyat    decimal.Decimal `json:"fiyat"`
	Miktar   decimal.Decimal `json:"miktar"`
	ImageUrl string          `json:"imageUrl"`
}

