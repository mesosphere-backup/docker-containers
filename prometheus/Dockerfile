FROM prom/prometheus
MAINTAINER Mesosphere <support@mesosphere.io>

ADD prometheus.yml.template /etc/prometheus/
ADD run /

ENTRYPOINT [ "/run" ]
