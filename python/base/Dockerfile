# Configure a Debian testing distro to run Tox for Python 2.7 and 3.4
FROM ubuntu:trusty
MAINTAINER Mesosphere, Inc. <support@mesosphere.io>
RUN apt-get update && \
    apt-get install -y python python3 python-pip python3-pip python-dev python3-dev && \
    apt-get clean