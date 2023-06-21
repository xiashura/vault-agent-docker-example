package main

import (
	"encoding/json"
	"log"
	"net/http"
)

type Secrets struct {
	User     string `json:"user"`
	Password string `json:"password"`
	Id       int    `json:"id"`
}

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		var sec Secrets

		err := json.NewDecoder(r.Body).Decode(&sec)
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
		}

		log.Printf("user:%s,password:%s,id:%d",
			sec.User,
			sec.Password,
			sec.Id)
	})

	log.Fatal(http.ListenAndServe(":8080", nil))
}
