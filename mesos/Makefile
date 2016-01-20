all: help

help:
	@echo 'Options available:'
	@echo '  make images VERSION=0.21.0-1.0.debian77'
	@echo '  make push   VERSION=0.21.0-1.0.debian77'
	@echo ''
	@echo 'VERSION should be set to the full Debian 7 Mesos package version'

check-version:
ifndef VERSION
	@echo "Error: VERSION is undefined."
	@make --no-print-directory help
	@exit 1
endif

images: check-version mesos mesos-master mesos-slave

push: check-version
	docker push mesosphere/mesos:$(VERSION)
	docker push mesosphere/mesos-master:$(VERSION)
	docker push mesosphere/mesos-slave:$(VERSION)

mesos: check-version
	sed "s/VERSION/$(VERSION)/g" dockerfile-templates/$@ > $@
	docker build -t mesosphere/$@:$(VERSION) - < $@

mesos-master: mesos check-version
	sed "s/VERSION/$(VERSION)/g" dockerfile-templates/$@ > $@
	docker build -t mesosphere/$@:$(VERSION) - < $@

mesos-slave: mesos check-version
	sed "s/VERSION/$(VERSION)/g" dockerfile-templates/$@ > $@
	docker build -t mesosphere/$@:$(VERSION) - < $@
