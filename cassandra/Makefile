
all: help

help:
	@echo 'Options available:"'
	@echo '  make image VERSION=2.0.x'
	@echo '  make push  VERSION=2.0.x'

check-version:
ifndef VERSION
	@echo "Error: VERSION is undefined."
	@make --no-print-directory help
	@exit 1
endif

image: check-version
	sed -r -e "s/VERSION/$(VERSION)/g" install/Dockerfile.template > install/Dockerfile
	sudo docker build -t mesosphere/cassandra:$(VERSION) install/
	rm -f install/Dockerfile

push: check-version
	sudo docker push mesosphere/cassandra:$(VERSION)
