# Extend the marathon docker image to also include zookeeper and python so that
# we can run integration tests
FROM mesosphere/python-test:latest
MAINTAINER Mesosphere, Inc. <support@mesosphere.io>
RUN pip install -U pip
RUN pip install -U dcoscli
