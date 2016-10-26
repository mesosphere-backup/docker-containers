
.PHONY: build
build:
	docker build -f Dockerfile.rfc2307 -t mesosphere/openldap-1.1.6:rfc2307 .
	docker build -f Dockerfile.rfc2307bis -t mesosphere/openldap-1.1.6:rfc2307bis .
push:
	docker push mesosphere/openldap-1.1.6:rfc2307
	docker push mesosphere/openldap-1.1.6:rfc2307bis
