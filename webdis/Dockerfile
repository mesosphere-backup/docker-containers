FROM ubuntu:trusty
MAINTAINER Mesosphere support@mesosphere.io

# Based on:
# https://github.com/nicolasff/webdis/blob/master/Dockerfile

RUN apt-get update -y \
    && apt-get install -yqq python-pip \
    && pip install envtpl \
    && apt-get clean
# Current dir is "/" at this point. And we are root.
RUN apt-get -y --force-yes install wget make gcc libevent-dev
RUN apt-get -y --force-yes install redis-server
RUN wget --no-check-certificate https://github.com/nicolasff/webdis/archive/0.1.2.tar.gz -O webdis-0.1.2.tar.gz
RUN tar -xvzf webdis-0.1.2.tar.gz
RUN cd webdis-0.1.2 && make && make install && cd ..
RUN rm -rf webdis-0.1.2 webdis-0.1.2.tar.gz
#RUN apt-get remove -y wget make gcc

ADD ./webdis.json.tpl /etc/webdis.json.tpl
ADD run.sh /root/run.sh
RUN chmod +x /root/run.sh

ENTRYPOINT ["/root/run.sh"]

EXPOSE 7379

