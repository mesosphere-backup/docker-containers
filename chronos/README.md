# Chronos docker container

Parameterized on chronos version and mesos version

Build the docker container for a specific chronos, mesos:
````
./mk.sh <chronos-version> <mesos-version>
```

Example:
```
./mk.sh 2.3.0-0.1.20141121000021 0.21.0-1.0.ubuntu1404
```
Check chronos logs:
````
docker exec <chronos container id> /bin/bash -c "tailf /var/log/messages"
```
