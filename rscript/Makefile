.PHONY: build
build:
	docker build -t mesosphere/rscript-curl - < rscript-curl
	docker build -t mesosphere/rscript-curl-aws - < rscript-curl-aws
	docker build -t mesosphere/rscript-curl-aws-java - < rscript-curl-aws-java
push:
	docker push mesosphere/rscript-curl
	docker push mesosphere/rscript-curl-aws
	docker push mesosphere/rscript-curl-aws-java
