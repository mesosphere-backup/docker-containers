Note:
Mesos should be run with Docker host networking (`--net=host`).
Additionally, the Mesos slave container should be run with a shared PID namespace (`--pid=host`), otherwise zombie processes will be left (mesosphere/docker-containers#9).
