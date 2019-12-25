SHELL := /bin/bash

BUILD_TAG := latest

-include .env

.EXPORT_ALL_VARIABLES:
.ONESHELL:

## docker-build-fluentd: Build fluentd image
docker-build-fluentd:
	docker build -t odahu/fluentd:${BUILD_TAG} -f containers/fluentd/Dockerfile .

## docker-push-fluentd: Push fluentd docker image
docker-push-fluentd:
	docker tag odahu/fluentd:${BUILD_TAG} ${DOCKER_REGISTRY}odahu/fluentd:${TAG}
	docker push ${DOCKER_REGISTRY}odahu/fluentd:${TAG}

## install-vulnerabilities-checker: Install the vulnerabilities-checker
install-vulnerabilities-checker:
	./install-git-secrets-hook.sh install_binaries

## check-vulnerabilities: Сheck vulnerabilities in the source code
check-vulnerabilities:
	./install-git-secrets-hook.sh install_hooks
	git secrets --scan -r

## help: Show the help message
help: Makefile
	@echo "Choose a command run in "$(PROJECTNAME)":"
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sort | sed -e 's/\\$$//' | sed -e 's/##//'
	@echo
