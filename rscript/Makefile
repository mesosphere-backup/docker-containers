
.PHONY: build
build:
    docker build -t mesosphere/rscript-curl - < rscript-curl
    docker build -t mesosphere/rscript-curl-aws - < rscript-curl-aws
push:
    docker push mesosphere/rscript-curl
    docker push mesosphere/rscript-curl-aws
