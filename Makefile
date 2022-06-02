# Docker image configuration
IMAGE_NAME := rafayak/ovpn-connector
IMAGE_TAG ?= latest

# Builds a given docker container image.
.PHONY: $(IMAGE_NAME)
$(IMAGE_NAME):
	@echo "Building Docker image $@:$(IMAGE_TAG)..."
	docker build -f Dockerfile -t $@:$(IMAGE_TAG) .

## image:			Builds docker image
.PHONY: image
image:
	$(MAKE) $(IMAGE_NAME) IMAGE_TAG=$(IMAGE_TAG)

## push:			Pushes the docker image to image repository
.PHONY: push
push:
	docker push $(IMAGE_NAME):$(IMAGE_TAG)

## help:			Display help
.PHONY: help
help: Makefile
	@sed -n 's/^##//p' $<
