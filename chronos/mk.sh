#!/bin/bash

# Wait for the specified number of entries to show up for the
# specified SkyDNS name.
set -e

if [ "${#}" -ne 2 ]; then
    echo "usage: ${0} {chronos-version} {mesos-version} {repo} [{image_tag}]"
    echo ""
    echo "  If a deb package exists in CWD with {chronos-version} in the name,"
    echo "  it will be used, otherwise chronos will be pulled from the package"
    echo "  repositories."
    echo "  For {repo} specify org/repository like 'ethos/chronos' for Adobe Platform."
    echo "  If you want to specify non-DockerHub.com registry, use environment variable 'DOCKER_REGISTRY',"
    echo "    Ex: 'export DOCKER_REGISTRY=docker-ethos-core-univ-release.dr-uw2.adobeitc.com' for Adobe Platform registry."
    echo "  Specify '{image_tag}' to override default tag, which is 'chronos-{chronos_version}-mesos-{mesos-version}'."
    exit 1
fi

CHRONOS_VERSION=${1}
MESOS_VERSION=${2}
REPO=${3}
FULL_VERSION="chronos-$CHRONOS_VERSION-mesos-$MESOS_VERSION"
if [[ "${4}" != "" ]] ; then
  IMAGE_TAG=${4}
else
  IMAGE_TAG="$FULL_VERSION"
fi
if [[ "$DOCKER_REGISTRY" != "" ]] ; then
  DOCKER_REGISTRY="${DOCKER_REGISTRY}/"
echo "$IMAGE_TAG" > docker-tag
CHRONOS_PKG=$(shopt -s nullglob; echo chronos_*${CHRONOS_VERSION}*.deb)
if test -n "$CHRONOS_PKG"
then
  echo "building with local behance chronos package: ${CHRONOS_PKG}"
  cp chronos-local-behance-template Dockerfile
  sed -i -e "s/CHRONOS_PKG/${CHRONOS_PKG}/g" Dockerfile
else
  echo "WARNING: building with chronos from package repositories"
  cp chronos-template Dockerfile
  echo "CHRONOS_VERSION is set to ${CHRONOS_VERSION} in Dockerfile"
  sed -i -e "s/CHRONOS_VERSION/${CHRONOS_VERSION}/g" Dockerfile
fi

echo "MESOS_VERSION is set to ${MESOS_VERSION} in Dockerfile"
sed -i -e "s/MESOS_VERSION/${MESOS_VERSION}/g" Dockerfile

docker build -t "${DOCKER_REGISTRY}${REPO}:${IMAGE_TAG}" .
echo "to push: \"docker push ${DOCKER_REGISTRY}${REPO}:${IMAGE_TAG}\""
rm -f Dockerfile
