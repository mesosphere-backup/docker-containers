FROM mesosphere/python-base:16.04
MAINTAINER Mesosphere, Inc. <support@mesosphere.io>
RUN pip install --upgrade dogapi requests mandrill prettytable
RUN apt-get update
RUN apt-get install -y python-mysql.connector