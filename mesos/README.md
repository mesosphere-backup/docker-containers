# Mesos in Docker

[Mesosphere](https://mesosphere.com/) builds [Apache Mesos](http://mesos.apache.org/) into several [Docker](https://www.docker.com/) containers:

- [mesosphere/mesos](https://hub.docker.com/r/mesosphere/mesos/) - Both the master and slave in the same container. Requires a custom command to run.
- [mesosphere/mesos-master](https://hub.docker.com/r/mesosphere/mesos-master/) - Mesos-Master only
- [mesosphere/mesos-slave](https://hub.docker.com/r/mesosphere/mesos-slave/) - Mesos-Slave only

Dockerfiles: https://github.com/mesosphere/docker-containers/tree/master/mesos

Other Mesosphere Packages: https://mesosphere.com/downloads/


## Machines

The recommended way to run Mesos in Docker is to run each master and slave container on their own machine, with their own IP.

## Networking

Host networking (`--net=host`) is recommended. While Mesos *can* operate in bridge networking, it is slower and has many caveats and configuration complexities.


## Example: Local Dev/Test

For development or experimentation, one Master and one Slave can be run on the same machine.

The following commands set up a local development environment with Exhibitor/Zookeeper, Mesos-Master, and Mesos-Slave, using host networking. This is not fit for production.

Caveats:
- Docker containers launched by the Mesos-Slave will continue running on the host after the Mesos-Slave container has been stopped.
- Docker volumes created by the Mesos-Slave will be relative to the host, not the Mesos-Slave container.

### Launch Exhibitor (Zookeeper)

[Exhibitor Configuration Reference](https://github.com/Netflix/exhibitor/wiki/Running-Exhibitor)

```
docker run -d --net=host netflixoss/exhibitor:1.5.2
```

### Launch Mesos-Master

[Master Configuration Reference](https://open.mesosphere.com/reference/mesos-master/)

```
docker run -d --net=host \
  -e MESOS_PORT=5050 \
  -e MESOS_ZK=zk://127.0.0.1:2181/mesos \
  -e MESOS_QUORUM=1 \
  -e MESOS_REGISTRY=in_memory \
  -e MESOS_LOG_DIR=/var/log/mesos \
  -e MESOS_WORK_DIR=/var/tmp/mesos \
  -v "$(pwd)/log/mesos:/var/log/mesos" \
  -v "$(pwd)/tmp/mesos:/var/tmp/mesos" \
  mesosphere/mesos-master:0.28.0-2.0.16.ubuntu1404
```

### Launch Mesos-Slave

[Slave Configuration Reference](https://open.mesosphere.com/reference/mesos-slave/)

```
docker run -d --net=host --privileged \
  -e MESOS_PORT=5051 \
  -e MESOS_MASTER=zk://127.0.0.1:2181/mesos \
  -e MESOS_SWITCH_USER=0 \
  -e MESOS_CONTAINERIZERS=docker,mesos \
  -e MESOS_LOG_DIR=/var/log/mesos \
  -e MESOS_WORK_DIR=/var/tmp/mesos \
  -v "$(pwd)/log/mesos:/var/log/mesos" \
  -v "$(pwd)/tmp/mesos:/var/tmp/mesos" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /cgroup:/cgroup \
  -v /sys:/sys \
  -v /usr/local/bin/docker:/usr/local/bin/docker \
  mesosphere/mesos-slave:0.28.0-2.0.16.ubuntu1404
```
