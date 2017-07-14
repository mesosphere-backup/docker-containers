NS = mesosphere
NAME = dcos-commons-tls-nginx
VERSION = latest

.PHONY: build
build:
	docker build -t $(NS)/$(NAME):$(VERSION) -f Dockerfile .

.PHONY: push
push: build
	docker push $(NS)/$(NAME):$(VERSION)