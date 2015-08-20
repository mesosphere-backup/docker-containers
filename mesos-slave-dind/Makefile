all: help

help:
	@echo 'Options available:'
	@echo '  make images VERSION=0.23.0-1.0.ubuntu1404.docker181 MESOS_VERSION=0.23.0-1.0.ubuntu1404 DOCKER_VERSION=1.8.1-0~trusty'
	@echo '  make push   VERSION=0.23.0-1.0.ubuntu1404.docker181'
	@echo ''
	@echo 'VERSION should include the Mesos, Ubuntu, and Docker versions'
	@echo 'DOCKER_VERSION should be the docker-engine version to install with apt-get (>= 1.8.0)'

check-version:
ifndef VERSION
	@echo "Error: VERSION is undefined."
	@make --no-print-directory help
	@exit 1
endif

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

images: check-version mesos-slave-dind

push: check-version
	docker push mesosphere/mesos-slave-dind:$(VERSION)

mesos-slave-dind: check-version check-mesos-version check-docker-version
	sed "s/DOCKER_VERSION/$(DOCKER_VERSION)/g;s/MESOS_VERSION/$(MESOS_VERSION)/g" dockerfile-templates/$@ > $@
	docker build -t mesosphere/$@:$(VERSION) -f $@ .
