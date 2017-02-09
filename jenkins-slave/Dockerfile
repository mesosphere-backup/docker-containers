FROM java:7

RUN apt-get update && \
    apt-get -y install apt-transport-https make maven node scala python-pip python3
RUN pip install virtualenv
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN sh -c "echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
RUN apt-get update && \
    apt-get -y install lxc-docker-1.5.0

# Needed to run Chronos.  See https://github.com/mesos/chronos/issues/211
RUN cd /usr/share/maven/lib && ln -s ../../common-lang.jar .
