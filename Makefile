#!/usr/bin/make -f

#-------------------------------------------------------------------------------
# Main variables
#-------------------------------------------------------------------------------

#--
# where to generate the artifacts
TARGET_DIR=target

#--
# source dir
SRC_DIR=src

#--
# artifact coordinates
PROJECT_VERSION=$(shell cat VERSION)

#--
# artifact name
ARTIFACT=apache-php

#--
# package name
PACKAGE=${ARTIFACT}-${PROJECT_VERSION}.zip

#-------------------------------------------------------------------------------
# Docker variables
#-------------------------------------------------------------------------------
DOCKER_IMAGE_NAME=apache-php
DOCKER_IMAGE_VERSION=$(shell cat VERSION)

DOCKER_USERNAME=fbarmes

#------------------------------------------------------------------------------
# script internals
#-------------------------------------------------------------------------------
#-- base image name per architecture
BASE_IMAGE_ARM=fbarmes/rpi-debian:1.0-SNAPSHOT-buster-slim

BASE_IMAGE_X64=debian:buster-slim


#-------------------------------------------------------------------------------
.PHONY: echo
echo:
	@echo ""
	@echo "--------------------------------------------"
	@echo " Makefile parameters"
	@echo "--------------------------------------------"
	@echo ""
	@echo "DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME}"
	@echo "DOCKER_IMAGE_VERSION=${DOCKER_IMAGE_VERSION}"



#-------------------------------------------------------------------------------
# Targets run inside builder image
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
.PHONY: init
init:
	@echo "init - START"
	@echo "init - DONE"

#-------------------------------------------------------------------------------
.PHONY: clean
clean:
	@echo "clean"



#-------------------------------------------------------------------------------
# Docker build
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
.PHONY: docker-build
docker-build:
	docker build \
		-t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} \
		-f Dockerfile \
		.


#-------------------------------------------------------------------------------
.PHONY: docker-run
docker-run:
	docker run \
		-it --rm \
		-p 80:80 \
		${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}


#-------------------------------------------------------------------------------
.PHONY: docker-run-bash
docker-run-bash:
	docker run \
		-it --rm \
		--entrypoint sh \
		${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}


#-------------------------------------------------------------------------------
# Docker publish
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
.PHONY: docker-login
docker-login:
	docker login -u $(DOCKER_USERNAME) -p $(DOCKER_PASSWORD)

#-------------------------------------------------------------------------------
.PHONY: docker-push
docker-push:
	#
	docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}
	#
	docker push ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}


#-------------------------------------------------------------------------------
.PHONY: docker-push-latest
docker-push-latest:
	#
	docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:latest
	#
	docker push ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:latest
