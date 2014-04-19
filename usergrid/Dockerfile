FROM dockerfile/java
MAINTAINER Mesosphere support@mesosphere.io

RUN apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install maven

RUN git clone https://github.com/usergrid/usergrid.git
RUN cd usergrid && git checkout tags/v1.0
RUN cd usergrid/stack && mvn clean install -DskipTests=true

RUN mkdir -p /opt/usergrid/stack/launcher
RUN cp -rp usergrid/stack/launcher/target /opt/usergrid/stack/launcher/

CMD cd /opt/usergrid/stack/launcher && \
    java -Xmx1G -jar target/usergrid-launcher-*-SNAPSHOT.jar -db -init -nogui

EXPOSE 8080
