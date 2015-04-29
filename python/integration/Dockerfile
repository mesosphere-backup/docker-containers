# Extend the marathon docker image to also include zookeeper and python so that
# we can run integration tests
FROM mesosphere/python-test:latest
MAINTAINER Mesosphere, Inc. <support@mesosphere.io>
RUN echo "deb http://repos.mesosphere.io/ubuntu trusty main" > \
      /etc/apt/sources.list.d/mesosphere.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
    apt-get update && \
    apt-get install -y openjdk-7-jre-headless mesos marathon=0.8.2-1.0.239.ubuntu1404 zookeeper git && \
    apt-get clean
