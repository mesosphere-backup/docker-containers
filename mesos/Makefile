SHORT_VERSION=`echo "$(VERSION)" | sed -E "s|^(.*)-(.*)$$|\1|"`
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
	docker push mesosphere/mesos:$(VERSION)
	docker push mesosphere/mesos:$(SHORT_VERSION)
	docker push mesosphere/mesos-master:$(VERSION)
	docker push mesosphere/mesos-master:$(SHORT_VERSION)
	docker push mesosphere/mesos-slave:$(VERSION)
	docker push mesosphere/mesos-slave:$(SHORT_VERSION)

mesos: check-version
	sed "s/VERSION/$(VERSION)/g" dockerfile-templates/$@ > $@
	if test `echo $(VERSION) | grep rc`; then \
	  sed "s/trusty/trusty-testing/g" dockerfile-templates/$@ > $@ ; \
	fi
	docker build -t mesosphere/$@:$(VERSION) - < $@
	docker tag mesosphere/$@:$(VERSION) mesosphere/$@:$(SHORT_VERSION) < $@

mesos-master: mesos check-version
	sed "s/VERSION/$(VERSION)/g" dockerfile-templates/$@ > $@
	docker build -t mesosphere/$@:$(VERSION) - < $@
	docker tag mesosphere/$@:$(VERSION) mesosphere/$@:$(SHORT_VERSION) < $@

mesos-slave: mesos check-version
	sed "s/VERSION/$(VERSION)/g" dockerfile-templates/$@ > $@
	docker build -t mesosphere/$@:$(VERSION) - < $@
	docker tag mesosphere/$@:$(VERSION) mesosphere/$@:$(SHORT_VERSION) < $@
