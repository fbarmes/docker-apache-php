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
# Targets run inside builder image
#-------------------------------------------------------------------------------


# #-------------------------------------------------------------------------------
# .PHONY: dev-deps
# dev-deps: init ${TARGET_DIR}/dev-deps.touch
#
# #-------------------------------------------------------------------------------
# .PHONY: dev-cleandeps
# dev-cleandeps: init
# 	rm ${TARGET_DIR}/deps.touch
#
#
# #-------------------------------------------------------------------------------
# ${TARGET_DIR}/dev-deps.touch:
# 	@#-- make artifact dir
# 	pip3 install -r requirements.txt -t ${TARGET_DIR}/${ARTIFACT}
# 	touch ${TARGET_DIR}/dev-deps.touch
#
# #-------------------------------------------------------------------------------
# .PHONY: dev-build
# dev-build: dev-deps
# 	cp -rp ${SRC_DIR}/* ${TARGET_DIR}/${ARTIFACT}/


#-------------------------------------------------------------------------------
# Docker build
#-------------------------------------------------------------------------------

#--
# bin/qemu-arm-static:
# 	#-- build qemu binary
# 	mkdir -p bin
# 	wget ${QEMU_URL} --output-document bin/qemu-arm-static.tar.gz
# 	tar -zxvf bin/qemu-arm-static.tar.gz -C ./bin
# 	rm bin/qemu-arm-static.tar.gz

#-------------------------------------------------------------------------------
# .PHONY: docker-build-dev
# docker-build-dev: init
#
# 	#-- register cpu emulation
# 	docker run --rm --privileged multiarch/qemu-user-static:register --reset
#
# 	docker build \
# 		--build-arg BASE_IMAGE=${BASE_IMAGE_ARM} \
# 		-t speedtest-exporter-builder \
# 		--target dev \
# 		-f Dockerfile \
# 		.

#-------------------------------------------------------------------------------
# .PHONY: docker-run-dev
# docker-run-dev: init
#
# 	#-- register cpu emulation
# 	docker run --rm --privileged multiarch/qemu-user-static:register --reset
#
# 	docker run \
# 		-it --rm \
# 		-v ${PWD}/${SRC_DIR}:/workdir/src \
# 		speedtest-exporter-builder


#-------------------------------------------------------------------------------
# .PHONY: docker-build-arm
# docker-build-arm:
#
# 	#-- register cpu emulation
# 	docker run --rm --privileged multiarch/qemu-user-static:register --reset
#
# 	docker build \
# 		--build-arg BASE_IMAGE=${BASE_IMAGE_ARM} \
# 		-t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}-arm \
# 		-f Dockerfile \
# 		.

#-------------------------------------------------------------------------------
# .PHONY: docker-build-x64
# docker-build-x64:
# 	docker build \
# 		--build-arg BASE_IMAGE=${BASE_IMAGE_ARM} \
# 		-t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}-x64 \
# 		-f Dockerfile \
# 		.


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
docker-push: docker-login
	#
	docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}-arm ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}-arm
	docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}-x64 ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}-x64
	#
	docker push ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}-arm
	docker push ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}-x64


#-------------------------------------------------------------------------------
.PHONY: docker-push-latest
docker-push-latest: docker-login
	#
	docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}-arm ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:latest-arm
	docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}-x64 ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:latest-x64
	#
	docker push ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:latest-arm
	docker push ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:latest-x64
