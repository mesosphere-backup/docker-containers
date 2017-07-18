NS = mesosphere
NAME = shibboleth-idp
VERSION = latest

.PHONY: build

build:
	docker build -t $(NS)/$(NAME):$(VERSION) -f Dockerfile .

push: build
	docker push $(NS)/$(NAME):$(VERSION)