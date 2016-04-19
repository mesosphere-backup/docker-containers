# Jenkins Docker-in-Docker Agent
[![Docker Stars](https://img.shields.io/docker/stars/mesosphere/jenkins-dind.svg)][docker-hub]
[![Docker Pulls](https://img.shields.io/docker/pulls/mesosphere/jenkins-dind.svg)][docker-hub]
[![Image Size](https://img.shields.io/imagelayers/image-size/mesosphere/jenkins-dind/0.2.2.svg)](https://imagelayers.io/?images=mesosphere/jenkins-dind:0.2.2)
[![Image Layers](https://img.shields.io/imagelayers/layers/mesosphere/jenkins-dind/0.2.2.svg)](https://imagelayers.io/?images=mesosphere/jenkins-dind:0.2.2)

A simple Docker image for running a Jenkins agent alongside its very
own Docker daemon. This is useful if you're trying to run Jenkins agents on a
Mesos cluster, and you also want to build and push Docker images using your
CI system.

For full documentation on how to use this Docker image, please refer to
<http://mesosphere.github.io/jenkins-mesos/docs/builds.html>.

## Usage
### Command line
Try it out locally by running the following command:

```bash
docker run --privileged mesosphere/jenkins-dind \
  wrapper.sh java -version && docker run hello-world
```

### Jenkins
You'll need to configure the Mesos plugin on your Jenkins master to use this
image. You'll probably also want to give it a special slave label, so that you
don't unnecessarily run builds using the dind image. A relevant snippet of the
Mesos plugin within the Jenkins master's `config.xml` follows:

```xml
<org.jenkinsci.plugins.mesos.MesosSlaveInfo>
  <slaveCpus>0.1</slaveCpus>
  <slaveMem>512</slaveMem>
  <executorCpus>0.1</executorCpus>
  <maxExecutors>2</maxExecutors>
  <executorMem>128</executorMem>
  <remoteFSRoot>jenkins</remoteFSRoot>
  <idleTerminationMinutes>3</idleTerminationMinutes>
  <jvmArgs>
    -Xms16m -XX:+UseConcMarkSweepGC -Djava.net.preferIPv4Stack=true
  </jvmArgs>
  <jnlpArgs/>
  <containerInfo>
    <type>DOCKER</type>
    <dockerImage>mesosphere/jenkins-dind:0.1.5</dockerImage>
    <networking>BRIDGE</networking>
    <useCustomDockerCommandShell>true</useCustomDockerCommandShell>
    <customDockerCommandShell>wrapper.sh</customDockerCommandShell>
    <dockerPrivilegedMode>true</dockerPrivilegedMode>
    <dockerForcePullImage>false</dockerForcePullImage>
  </containerInfo>
  <mode>NORMAL</mode>
  <labelString>dind</labelString>
</org.jenkinsci.plugins.mesos.MesosSlaveInfo>
```

[docker-hub]: https://hub.docker.com/r/mesosphere/jenkins-dind
