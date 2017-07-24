FROM golang:alpine

MAINTAINER Mesosphere Support <support@mesosphere.com>

ENV PATH=/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV GOPATH=/go

RUN apk --no-cache \
    add ca-certificates curl \
    && rm -rf /var/cache/apk/*

ENV VAULT_VERSION=v0.7.3

RUN buildDeps=' \
        bash \
        git \
        gcc \
        g++ \
        libc-dev \
        libgcc \
        make \
        zip \
    ' \
    set -x \
    && apk --no-cache add $buildDeps \
    && mkdir -p /go/src/github.com/hashicorp \
    && git clone https://github.com/hashicorp/vault /go/src/github.com/hashicorp/vault \
    && cd /go/src/github.com/hashicorp/vault \
    && go get github.com/mitchellh/gox \
    && make bin \
    && mv bin/vault /usr/bin/ \
    && apk del \
    && rm -rf /go \
    && echo Build complete.

ENTRYPOINT ["/usr/bin/vault"]