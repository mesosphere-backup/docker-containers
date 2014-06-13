FROM stackbrew/ubuntu:14.04
MAINTAINER Mesosphere support@mesosphere.io

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get update && apt-get -y install \
  make \
  ruby-dev \
  python-pip \
  python-dev \
  libz-dev \
  protobuf-compiler \
  python-protobuf
RUN gem install fpm
RUN pip install bbfreeze

ENV LC_ALL C.UTF-8
WORKDIR /container
ENTRYPOINT ["make"]
CMD ["deb"]
