all: help

help:
	@echo 'Options available:'
	@echo '  make images VERSION=0.20.1-1.0.ubuntu1404'
	@echo '  make push   VERSION=0.20.1-1.0.ubuntu1404'
	@echo ''
	@echo 'VERSION should be set to the full Ubuntu 14.04 Mesos package version'

check-version:
ifndef VERSION
	@echo "Error: VERSION is undefined."
	@make --no-print-directory help
	@exit 1
endif

images: check-version mesos mesos-master mesos-slave

push: check-version
	sudo docker push mesosphere/mesos:$(VERSION)
	sudo docker push mesosphere/mesos-master:$(VERSION)
	sudo docker push mesosphere/mesos-slave:$(VERSION)

mesos: check-version
	sed -e "s/VERSION/$(VERSION)/g" dockerfile-templates/$@ > Dockerfile
	sudo docker build -t mesosphere/$@:$(VERSION) .
	rm -f Dockerfile

mesos-master: mesos check-version
	sed -e "s/VERSION/$(VERSION)/g" dockerfile-templates/$@ > Dockerfile
	sudo docker build -t mesosphere/$@:$(VERSION) .
	rm -f Dockerfile

mesos-slave: mesos check-version
	sed -e "s/VERSION/$(VERSION)/g" dockerfile-templates/$@ > Dockerfile
	sudo docker build -t mesosphere/$@:$(VERSION) .
	rm -f Dockerfile
