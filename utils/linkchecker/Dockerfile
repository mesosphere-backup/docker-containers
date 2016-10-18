FROM mesosphere/python-monitoring:16.04
MAINTAINER Mesosphere, Inc. <support@mesosphere.io>

RUN pip uninstall -y requests
RUN apt-get install -y python-requests
RUN pip install urllib3[secure]
ADD http://ftp.debian.org/debian/pool/main/l/linkchecker/linkchecker_9.3-1_amd64.deb /tmp/linkchecker_9.3-1_amd64.deb

RUN dpkg -i /tmp/linkchecker_9.3-1_amd64.deb
