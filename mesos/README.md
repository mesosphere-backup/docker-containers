Notes:
* Mesos should be run with Docker host networking (`--net=host`).
* Additionally, the Mesos slave container should be run with a shared PID namespace (`--pid=host`), otherwise the Mesos slave container will leave zombie processes ([mesosphere/docker-containers#9|https://github.com/mesosphere/docker-containers/issues/9]).
