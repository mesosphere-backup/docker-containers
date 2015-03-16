FROM mesosphere/python-base:latest
MAINTAINER Mesosphere, Inc. <support@mesosphere.io>
RUN pip install --upgrade dogapi requests mandrill
RUN apt-get update
RUN apt-get install -y python-mysql.connector