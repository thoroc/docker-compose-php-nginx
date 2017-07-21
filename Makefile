# variables
#UNAME_S := $(shell uname -s)
INTERACTIVE:=$(shell [ -t 0 ] && echo 1)
IMAGE_NAME ?= docker-php-api
VERSION ?= latest

COMPOSER_CACHE_DIR = /var/tmp/composer

ifeq ($(COMPOSER_USE_INSTALL_FLAGS), 1)
    COMPOSER_INSTALL_FLAGS=--no-scripts --ignore-platform-reqs
endif

ifeq ($(INTERACTIVE), 1)
    DOCKER_INTERACTIVE_FLAG=-i
endif

.PHONY: help build dev stop
.DEFAULT_GOAL := help

# tasks
help: ## Displays list and descriptions of available targets
	@awk -F ':|\#\#' '/^[^\t].+:.*\#\#/ {printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF }' $(MAKEFILE_LIST) | sort

# If the first argument is one of the supported commands...
SUPPORTED_COMMANDS := build dev composer
SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(SUPPORTED_COMMANDS))
ifneq "$(SUPPORTS_MAKE_ARGS)" ""
    # use the rest as arguments for the command
    COMMAND_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
    # ...and turn them into do-nothing targets
    $(eval $(COMMAND_ARGS):;@:)
endif

build: ## Build Docker Image
	docker build -t $(IMAGE_NAME)/$(VERSION) -f etc/docker/$(COMMAND_ARGS)/Dockerfile .

dev: ## Run project in dev mode
ifeq ($(COMMAND_ARGS),)
	@docker-compose up
else
	@docker-compose up -d $(COMMAND_ARGS)
endif

stop: ## Stop all Docker Containers and remove Volumes
	@docker-compose down -v

composer: ## Composer - PHP dependencies management
	@docker run --rm --interactive --tty \
		--volume $PWD:/app \
		--user $(id -u):$(id -g) \
		composer $(COMMAND_ARGS)