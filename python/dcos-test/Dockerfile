# Extend the marathon docker image to also include zookeeper and python so that
# we can run integration tests
FROM mesosphere/python-test:latest
MAINTAINER Mesosphere, Inc. <support@mesosphere.io>
RUN pip install -U virtualenv
RUN virtualenv /dcos-cli
RUN /dcos-cli/bin/pip install -U dcoscli
ENV PATH /dcos-cli/bin:$PATH
RUN apt-get update && \
    apt-get install -y curl jq && \
    apt-get clean