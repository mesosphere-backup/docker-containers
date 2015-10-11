all: help

help:
	@echo 'Options available:'
	@echo '  make images MESOS_VERSION=0.23.0-1.0.ubuntu1404 DOCKER_VERSION=1.8.1-0~trusty'
	@echo '  make push   MESOS_VERSION=0.23.0-1.0.ubuntu1404 DOCKER_VERSION=1.8.1-0~trusty'
	@echo ''
	@echo 'MESOS_VERSION is the mesos base image version'
	@echo 'DOCKER_VERSION should be the docker-engine version to install with apt-get (>= 1.8.0)'

check-version:

check-mesos-version:
ifndef MESOS_VERSION
	@echo "Error: MESOS_VERSION is undefined."
	@make --no-print-directory help
	@exit 1
endif

check-docker-version:
ifndef DOCKER_VERSION
	@echo "Error: DOCKER_VERSION is undefined."
	@make --no-print-directory help
	@exit 1
endif

VERSION=mesos-$(MESOS_VERSION)-docker-$(subst ~,-,$(DOCKER_VERSION))

images: check-version mesos-slave-dind

push: check-version
	docker push mesosphere/mesos-slave-dind:$(VERSION)

mesos-slave-dind: check-version check-mesos-version check-docker-version
	sed "s/DOCKER_VERSION/$(DOCKER_VERSION)/g;s/MESOS_VERSION/$(MESOS_VERSION)/g" dockerfile-templates/$@ > $@
	docker build -t mesosphere/$@:$(VERSION) -f $@ .
