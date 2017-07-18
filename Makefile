# variables
#UNAME_S := $(shell uname -s)
IMAGE_NAME ?= docker-php-api
VERSION ?= latest

.DEFAULT_GOAL := help

# tasks
help: ## Displays list and descriptions of available targets
	@awk -F ':|\#\#' '/^[^\t].+:.*\#\#/ {printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF }' $(MAKEFILE_LIST) | sort

# If the first argument is one of the supported commands...
SUPPORTED_COMMANDS := build dev
SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(SUPPORTED_COMMANDS))
ifneq "$(SUPPORTS_MAKE_ARGS)" ""
  # use the rest as arguments for the command
  COMMAND_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(COMMAND_ARGS):;@:)
endif

build: ## Build Docker Image
	@echo "Building docker image: [$(COMMAND_ARGS)]"
	docker build -t $(IMAGE_NAME)/$(VERSION) -f etc/docker/$(COMMAND_ARGS)/Dockerfile .

dev: ## Run project in dev mode
	@echo "Running project [$(COMMAND_ARGS)] in dev mode"
	docker-compose up -d $(COMMAND_ARGS)