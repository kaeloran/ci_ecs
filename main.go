package main

import (
	"log"

	"ci_pipeline_docker/database"
	"ci_pipeline_docker/routes"

	"github.com/joho/godotenv"
)

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Println("Aviso: arquivo .env não encontrado, usando variáveis de ambiente do sistema")
	}

	database.ConectaComBancoDeDados()
	routes.HandleRequest()
}
