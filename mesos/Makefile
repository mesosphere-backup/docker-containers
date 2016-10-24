# Make version numbers more predictable.
# Convert
#   major.minor.patch-X.Y.Z.[rcNNN.]ubuntuYYMM
# to
#   major.minor.patch-[rcNNN.]ubuntuYYMM
MESOS_TAG=`echo "$(VERSION)" | sed -e "s|-[0-9]\+\.[0-9]\+\.[0-9]\+\.|-|"`
UBUNTU_CODENAME=trusty
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
	docker push mesosphere/mesos:$(MESOS_TAG)
	docker push mesosphere/mesos-master:$(MESOS_TAG)
	docker push mesosphere/mesos-slave:$(MESOS_TAG)

mesos: check-version
	echo $(VERSION)
	echo $(MESOS_TAG)
	cp dockerfile-templates/$@ $@
	sed -i -e "s/trusty/$(UBUNTU_CODENAME)/g" $@
	sed -i -e "s/{VERSION}/$(VERSION)/g" $@
	if test `echo $(VERSION) | grep rc`; then \
	  sed -i -e "s/{UBUNTU_TESTING}/-testing/g" $@ ; \
	else \
	  sed -i -e "s/{UBUNTU_TESTING}//g" $@ ; \
	fi
	docker build -t mesosphere/$@:$(MESOS_TAG) - < $@

mesos-master: mesos check-version
	sed "s/{VERSION}/$(VERSION)/g" dockerfile-templates/$@ > $@
	docker build -t mesosphere/$@:$(MESOS_TAG) - < $@

mesos-slave: mesos check-version
	sed "s/{VERSION}/$(VERSION)/g" dockerfile-templates/$@ > $@
	docker build -t mesosphere/$@:$(MESOS_TAG) - < $@
