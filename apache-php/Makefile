#!/usr/bin/make -f


#-------------------------------------------------------------------------------
# Docker variables
#-------------------------------------------------------------------------------
DOCKER_IMAGE_NAME=fbarmes/apache-php
DOCKER_IMAGE_VERSION=$(shell cat ../VERSION)


#-------------------------------------------------------------------------------
# Default target (all)
#-------------------------------------------------------------------------------
.PHONY: all
all: echo


#-------------------------------------------------------------------------------
.PHONY: build
build:
	docker build \
	--file Dockerfile \
	--tag ${DOCKER_IMAGE_NAME} \
	.

#-------------------------------------------------------------------------------
.PHONY: clean
clean:
	docker rmi fbarmes/apache-php

#-------------------------------------------------------------------------------
.PHONY: runfg
runfg:
	docker run -it --rm  -p 80:80 fbarmes/apache-php

#-------------------------------------------------------------------------------
.PHONY: run
run:
	docker run -d fbarmes/apache-php


#-------------------------------------------------------------------------------
# echo
#-------------------------------------------------------------------------------
echo:
	@echo "DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME}"
	@echo "DOCKER_IMAGE_VERSION=${DOCKER_IMAGE_VERSION}"
