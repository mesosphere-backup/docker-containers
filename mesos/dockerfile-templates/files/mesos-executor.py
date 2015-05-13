#!/usr/bin/python

import os
import sys
from docker import Client

# command args have to be passed like this "--override /bin/sh -c 'exit `docker wait <taks-container>`'"
# without the '' after -c it will not work
commandArgs = "%s '%s'" % (" ".join(sys.argv[1:4]), " ".join(sys.argv[4:]))

environmentVars = "".join(["%s=%s\n" % (k, v) for k, v in os.environ.items()])

print "[DEBUG] Environment:\n", environmentVars
print "[DEBUG] Arguments:\n", commandArgs

mesosImageRepo = "mesosphere/mesos-slave"
mesosImageTag = "0.21.1-1.1.ubuntu1404"
executorId = os.getenv("MESOS_EXECUTOR_ID")
executorName = "executor-%s" % executorId

# connect to the docker client
# Note: use localhost only when using HOST networking when starting the
# mesos-slave container
with Client(base_url="tcp://localhost:2375") as cli:
  #cli.pull(repository=mesosImageRepo, tag=mesosImageTag)

  container = cli.create_container(
    image="%s:%s" % (mesosImageRepo, mesosImageTag),
    stdin_open=True,
    environment=dict(os.environ),
    volumes=[
      "/sys",
      "/usr/bin/docker",
      "/var/run/docker.sock",
      "/lib/libdevmapper.so.1.02",
      "/etc/passwd",
      "/etc/group",
      "/var/lib/mesos/slave",
      "/var/log/mesos/slave"
    ],
    name=executorName,
    entrypoint="/usr/libexec/mesos/mesos-executor",
    command=commandArgs
  )

  response = cli.start(
    container=container.get("Id"),
    binds={
      "/sys":
        {
          "bind": "/sys",
          "ro": False
        },
      "/usr/bin/docker":
        {
          "bind": "/usr/bin/docker",
          "ro": True
        },
      "/var/run/docker.sock":
        {
          "bind": "/var/run/docker.sock",
          "ro": True
        },
      "/lib64/libdevmapper.so.1.02":
        {
          "bind": "/lib/libdevmapper.so.1.02",
          "ro": True
        },
      "/etc/passwd":
        {
          "bind": "/etc/passwd",
          "ro": True
        },
      "/etc/group":
        {
          "bind": "/etc/group",
          "ro": True
        },
      "/var/lib/mesos/slave":
        {
          "bind": "/var/lib/mesos/slave",
          "ro": False
        },
      "/var/log/mesos/slave":
        {
          "bind": "/var/log/mesos/slave",
          "ro": False
        }
    },
    privileged=True,
    network_mode="host",
    pid_mode="host"
  )

  # get the pid of the root process of the container
  topResult = cli.top(container.get("Id"))
  forkedPid = topResult["Processes"][0][1]
  # construct the path to the forked.pid
  pidFile = "%s/pids/forked.pid" % os.getenv("MESOS_DIRECTORY").replace("/slaves/", "/meta/slaves/", 1)

  # overwrite the existing pid with the new one of the container
  # othwerwise, it will not work because it will be the pid of the executed python
  # script, which will get killed when the slave container restarts
  with open(pidFile, "w") as pidFile:
    print "[DEBUG] Writing PID '%s' to file '%s'" % (forkedPid, pidFile)
    pidFile.write(forkedPid)

  exitCode = cli.wait(container=container.get("Id"), timeout=None)
  print "[DEBUG] Exited with code: ", exitCode

  cli.remove_container(container=container.get("Id"))

exit(exitCode)
