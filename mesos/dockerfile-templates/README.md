##Recovery for dockerized mesos-slave

The current problem with a dockerized Mesos slave is that the `mesos-executor` processes watching the Docker containers spawend by a task are created inside the Mesos slave container. Thus, when the Mesos slave container dies the `mesos-executor` processes die as well.

Mesos slave runs:
```
root       700  docker --daemon --host=fd://
root     16774  \_ mesos-master
root     25833  \_ mesos-slave
root     16088  |   \_ sh -c /usr/libexec/mesos/mesos-executor --override /bin/sh -c 'exit `docker wait mesos-46165245-a818-448f-ac6f-34e8b303db3e`'   # this is the executor watching the task container
root     16090  |   |   \_ /usr/libexec/mesos mesos-executor --override /bin/sh -c exit `docker wait mesos-46165245-a818-448f-ac6f-34e8b303db3e`
root     16114  |   |       \_ /bin/sh -c exit `docker wait mesos-46165245-a818-448f-ac6f-34e8b303db3e`
root     16115  |   |           \_ docker wait mesos-46165245-a818-448f-ac6f-34e8b303db3e
root     16089  |   \_ sh -c logs() {   docker logs --follow $1 &   pid=$!   docker wait $1 >/dev/null 2>&1   sleep 10   kill -TERM $pid >/dev/null 2>&1 &
root     16091  |   |   \_ docker logs --follow mesos-46165245-a818-448f-ac6f-34e8b303db3e
root     16092  |   |   \_ docker wait mesos-46165245-a818-448f-ac6f-34e8b303db3e
root     16075  \_ sudo -iu jenkins java       # this is the watched (Jenkins slave) container
jenkins  16161      \_ java -DHUDSON_HOME=/home/jenkins
```

Mesos slave dies:
```
root       700  docker --daemon --host=fd://
root     16774  \_ mesos-master
root     16075  \_ sudo -iu jenkins java       # this is the watched (Jenkins slave) container
jenkins  16161      \_ java -DHUDSON_HOME=/home/jenkins
```

Mesos slave restarts:
```
root       700  docker --daemon --host=fd://
root     16774  \_ mesos-master
root     25818  \_ mesos-slave
```

Normally, this would not happen. Because when the Mesos slave dies the `mesos-executor` process rebases to the root PID and will still run. Therefore, when the slave restarts it still sees the `mesos-executor` running - based on the meta data in the slave directory (`forked.pid`). This means that the restarted Mesos slave can reconnect the tasks.

However, in the case of a containerized Mesos slave the `mesos-executor` process is lost/killed. For that reason the Mesos slave cannot reconnect to it (the PID in `forked.pid` is now invalid) and will stop/kill all remaining and - from the viewpoint of the Mesos slave - unknown tasks. This is also observable in the log file of the Mesos slave.

To prevent this from happening, the idea is to start a `mesos-executor` outside the Mesos slave container. The easiest way to achieve this is, by starting a docker container which runs `mesos-executor` on the host system of the Mesos slave. Additionally, the `forked.pid` needs to be updated with the PID of the Docker container running `mesos-executor`. The Python code in `files/mesos-executor.py` shows an example of how to do this.

Basically, what the code does is, starting a Docker container with the arguments passed to the Python script. Then getting the PID of the root process in the container and writing it to `forked.pid`. Note that the script starts the container with `--pid=host` and with the Mesos slave directory mounted as a volume. Otherwise, this would not be possible.

To let the Mesos slave use the script, it is possible to mount it as a volume as `/usr/libexec/mesos/mesos-executor`. The script can also replace `/usr/libexec/mesos/mesos-executor` as a binary by creating a new Mesos slave image. The Dockerfile `mesos-slave` shows this as an example. Note that in both cases it is necessary to provide a Python executable and `docker-py`. The version of `docker-py` depends on the version of Docker on the host system.

When running the Mesos slave with the changed `mesos-executor` it now produces the following:
```
root       444  docker --daemon --host=fd://
root       863  \_ mesos-master
root      2458  \_ mesos-slave
root      4134  |   \_ sh -c /usr/libexec/mesos/mesos-executor --override /bin/sh -c 'exit `docker wait mesos-4c53e606-7c3a-4e53-9a55-8b51ab127a52`'
root      4138  |   |   \_ /usr/bin/python /usr/libexec/mesos/mesos-executor --override /bin/sh -c exit `docker wait mesos-4c53e606-7c3a-4e53-9a55-8b51ab12
root      4135  |   \_ sh -c logs() {   docker logs --follow $1 &   pid=$!   docker wait $1 >/dev/null 2>&1   sleep 10   kill -TERM $pid >/dev/null 2>&1 &
root      4136  |       \_ docker logs --follow mesos-4c53e606-7c3a-4e53-9a55-8b51ab127a52
root      4137  |       \_ docker wait mesos-4c53e606-7c3a-4e53-9a55-8b51ab127a52
root      4109  \_ java -DHUDSON_HOME=/home/jenkins
root      4164  \_ /usr/libexec/mesos mesos-executor --override /bin/sh -c exit `docker wait mesos-4c53e606-7c3a-4e53-9a55-8b51ab127a52`
root      4185      \_ /bin/sh -c exit `docker wait mesos-4c53e606-7c3a-4e53-9a55-8b51ab127a52`
root      4187          \_ docker wait mesos-4c53e606-7c3a-4e53-9a55-8b51ab127a52
```

Also, executing `docker ps` shows the running Mesos executor container:
```
CONTAINER ID        IMAGE                                                       COMMAND                CREATED             STATUS              PORTS               NAMES
782f759eb6bd        mesosphere/mesos-slave:0.21.1-1.1.ubuntu1404                "/usr/libexec/mesos/   3 minutes ago       Up 3 minutes                            executor-mesos-b38cd78d-f4db-468e-8571-bc92ff8712b4
c9d309a11c94        mesosphere/mesos-slave:0.21.1-MODIFIED-1.1.ubuntu1404       "mesos-slave --ip=17   2 hours ago         Up 2 hours                              mesos_slave
```

Now when the Mesos slave stops or dies, the `mesoss-executor` still lives:
```
root       444  docker --daemon --host=fd://
root       863  \_ mesos-master
root      4109  \_ java -DHUDSON_HOME=/home/jenkins
root      4164  \_ /usr/libexec/mesos mesos-executor --override /bin/sh -c exit `docker wait mesos-4c53e606-7c3a-4e53-9a55-8b51ab127a52`
root      4185      \_ /bin/sh -c exit `docker wait mesos-4c53e606-7c3a-4e53-9a55-8b51ab127a52`
root      4187            \_ docker wait mesos-4c53e606-7c3a-4e53-9a55-8b51ab127a52
```

```
CONTAINER ID        IMAGE                                                       COMMAND                CREATED             STATUS              PORTS               NAMES
782f759eb6bd        mesosphere/mesos-slave:0.21.1-1.1.ubuntu1404                "/usr/libexec/mesos/   10 minutes ago      Up 10 minutes                           executor-mesos-b38cd78d-f4db-468e-8571-bc92ff8712b4
```


Upon restarting the Mesos slave, the task and the executor are still working as well:
```
root       444  docker --daemon --host=fd://
root      4109  \_ java -DHUDSON_HOME=/home/jenkins
root      4164  \_ /usr/libexec/mesos mesos-executor --override /bin/sh -c exit `docker wait mesos-4c53e606-7c3a-4e53-9a55-8b51ab127a52`
root      4185  |   \_ /bin/sh -c exit `docker wait mesos-4c53e606-7c3a-4e53-9a55-8b51ab127a52`
root      4187  |       \_ docker wait mesos-4c53e606-7c3a-4e53-9a55-8b51ab127a52
root      4415  \_ mesos-slave
```

```
CONTAINER ID        IMAGE                                                       COMMAND                CREATED             STATUS              PORTS               NAMES
845b4ffe507f        mesosphere/mesos-slave:0.21.1-MODIFIED-1.1.ubuntu1404       "mesos-slave --ip=17   8 seconds ago       Up 7 seconds                            mesos_slave
782f759eb6bd        mesosphere/mesos-slave:0.21.1-1.1.ubuntu1404                "/usr/libexec/mesos/   11 minutes ago      Up 11 minutes                           executor-mesos-b38cd78d-f4db-468e-8571-bc92ff8712b4
```

Therefore, the somewhat hacked `mesos-executor` binary resolves the recovery issue with containerized Mesos slaves (https://github.com/mesosphere/docker-containers/issues/6 mentions this)

###Notes
* The process `sh -c logs() ...` gets killed no matter what. This probably would need changes in the Mesos code.
  * What this means is, that some logs are lost forever.
* Also, the Python process in the Mesos slave container dies and therefore does not call `cli.remove_container()`.
  * This leads to potential left-over, exited containers on the host.
  * Workaround this with a cron job removing all the exited containers (the garbage collection of Mesos does ignore them AFAIK).
* Use `executor-mesos-<UUID>` as container name.
  * Otherwise Mesos slave will kill it upon restart.
  * I don't know if it has to be a leading `executor-` but I'm sure it has to contain the executor id (`mesos-<UUID>`).
