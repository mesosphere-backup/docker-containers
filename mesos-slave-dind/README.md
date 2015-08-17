### Mesos Slave Docker-in-Docker (dind)

Mesos-Slave that runs in a Ubuntu-based Docker container.

Launches tasks using the included Docker Engine, rather than the host's Docker Engine.

#### Features

- Runs Mesos tasks inside the container (instead of in the parent Docker env).
- Allocates IP space on the parent Docker's network, making docker-in-docker containers IP accessible from the host.
- Mesos tasks (in docker containers) are stopped when the mesos-slave-dind container is stopped.

#### Required Docker Parameters

- `--privileged=true` - Requires access to cgroups and `/var/lib/docker`
- `-v /var/lib/docker` - Requires a mountable file-system for docker images (e.g not AUFS/SMBFS/CIFS)

#### Recommended Environment Variables

- **MESOS_CONTAINERIZERS** - Include docker to enable running tasks as docker containers. Ex: `docker,mesos`
- **MESOS_RESOURCES** - Specify resources to avoid oversubscribing via auto-detecting host resources. Ex: `cpus:4;mem:1280;disk:25600;ports:[21000-21099]`
- **DOCKER_NETWORK_OFFSET** - Specify an IP offset to give each mesos-slave-dind container.  Default: `0.0.1.0` Ex: `0.0.1.0` (slave A), `0.0.2.0` (slave B)
- **DOCKER_NETWORK_SIZE** - Specify a CIDR range to apply to the above offset. Default: `24`

Source: <https://github.com/mesosphere/docker-containers/tree/master/mesos>

PR (pending merge): <https://github.com/mesosphere/docker-containers/pull/21>

Inspiration: <https://github.com/jpetazzo/dind>
