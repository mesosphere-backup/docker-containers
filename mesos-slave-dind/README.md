### Mesos Slave Docker-in-Docker (dind)

Mesos-Slave that runs in a Ubuntu-based Docker container.

Launches tasks using the included Docker Engine, rather than the host's Docker Engine.

#### Features

- Runs Mesos tasks inside the container (instead of in the parent Docker env).
- Mesos tasks (in docker containers) are stopped when the mesos-slave-dind container is stopped.
- Supports OverlayFS (new hotness) and AUFS (legacy)
  - Allocates disk space (via loop mount) to allow mounting AUFS on AUFS
- Allocates IP space on the parent Docker's network, making docker-in-docker containers IP accessible from the host.

#### Required Docker Parameters

- `--privileged=true` - Provides access to cgroups

#### Recommended Environment Variables

- **MESOS_CONTAINERIZERS** - Include docker to enable running tasks as docker containers. Ex: `docker,mesos`
- **MESOS_RESOURCES** - Specify resources to avoid oversubscribing via auto-detecting host resources. Ex: `cpus:4;mem:1280;disk:25600;ports:[21000-21099]`
- **DOCKER_NETWORK_OFFSET** - Specify an IP offset to give each mesos-slave-dind container (default: `0.0.1.0`). Ex: `0.0.1.0` (slave A), `0.0.2.0` (slave B)
- **DOCKER_NETWORK_SIZE** - Specify a CIDR range to apply to the above offset (default=`24`).
- **VAR_LIB_DOCKER_SIZE** - Specify the max size (in GB) of the loop device to be mounted at /var/lib/docker (default=`5`). This is only used if OverlayFS is not supported by the kernel or the parent docker is configured to use AUFS.

Source: <https://github.com/mesosphere/docker-containers/tree/master/mesos-slave-dind>

Inspiration: <https://github.com/jpetazzo/dind>
