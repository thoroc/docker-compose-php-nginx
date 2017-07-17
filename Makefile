# variables
#UNAME_S := $(shell uname -s)
IMAGE_NAME ?= docker-php-api
VERSION ?= latest

.DEFAULT_GOAL := help
.PHONY: help build build_website build_site1-api build_site2-api build_site3-api

# tasks
help: ## Displays list and descriptions of available targets
	@awk -F ':|\#\#' '/^[^\t].+:.*\#\#/ {printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF }' $(MAKEFILE_LIST) | sort

build: build_website build_site1-api build_site2-api build_site3-api ## Build all Docker images

build_website: ## Build website Docker image
	docker build -t $(IMAGE_NAME)/$(VERSION) -f etc/docker/website/Dockerfile .

build_site1-api: ## Build site1-api Docker image
	docker build -t $(IMAGE_NAME)/$(VERSION) -f etc/docker/site1-api/Dockerfile .

build_site2-api: ## Build site2-api Docker image
	docker build -t $(IMAGE_NAME)/$(VERSION) -f etc/docker/site2-api/Dockerfile .

build_site3-api: ## Build site3-api Docker image
	docker build -t $(IMAGE_NAME)/$(VERSION) -f etc/docker/site3-api/Dockerfile .