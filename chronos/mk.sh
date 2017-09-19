#!/bin/bash

# Wait for the specified number of entries to show up for the
# specified SkyDNS name.
set -e

if [ "${#}" -ne 2 ]; then
    echo "usage: ${0} {chronos-version} {mesos-version}"
    echo ""
    echo "  If a deb package exists in CWD with {chronos-version} in the name,"
    echo "  it will be used, otherwise chronos will be pulled from the package"
    echo "  repositories."
    exit 1
fi

CHRONOS_VERSION=${1}
MESOS_VERSION=${2}

FULL_VERSION="chronos-$CHRONOS_VERSION-mesos-$MESOS_VERSION"
echo "$FULL_VERSION" > docker-tag

CHRONOS_PKG=$(shopt -s nullglob; echo chronos_*${CHRONOS_VERSION}*.deb)
if test -n "$CHRONOS_PKG"
then
  echo "building with local behance chronos package: ${CHRONOS_PKG}"
  cp chronos-local-behance-template Dockerfile
  sed -i -e "s/CHRONOS_PKG/${CHRONOS_PKG}/g" Dockerfile
else
  echo "WARNING: building with chronos from package repositories"
  cp chronos-template Dockerfile
  sed -i -e "s/CHRONOS_VERSION/${CHRONOS_VERSION}/g" Dockerfile
fi

sed -i -e "s/MESOS_VERSION/${MESOS_VERSION}/g" Dockerfile

docker build -t "behance/chronos:${FULL_VERSION}" .
echo "to push: \"docker push behance/chronos:${FULL_VERSION}\""
rm -f Dockerfile
