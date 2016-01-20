Mesos containers
================

Build
-----

```
make images VERSION=<Debian 7 Mesos pkg version>
```

Run mesos-master
----------------

```
# docker run -d \
    --net=host \
    mesosphere/mesos-master:<Debian 7 Mesos pkg version>
```

Run mesos-slave
---------------

```
# docker run -d \
    -e MESOS_MASTER=<master/zk URL> \
    --net=host \
    mesosphere/mesos-slave:<Debian 7 Mesos pkg version>
```
