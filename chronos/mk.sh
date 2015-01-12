#!/bin/bash

# Wait for the specified number of entries to show up for the
# specified SkyDNS name.
set -e

if [ "${#}" -ne 2 ]; then
    echo "usage: ${0} {chronos-version} {mesos-version}"
    exit 1
fi

CHRONOS_VERSION=${1}
MESOS_VERSION=${2}

FULL_VERSION="chronos-$CHRONOS_VERSION-mesos-$MESOS_VERSION"

cp chronos-template Dockerfile

sed -i -e "s/CHRONOS_VERSION/${CHRONOS_VERSION}/g" Dockerfile
sed -i -e "s/MESOS_VERSION/${MESOS_VERSION}/g" Dockerfile
docker build -t "mesosphere/chronos:${FULL_VERSION}" .
echo "to push: \"docker push mesosphere/chronos:${FULL_VERSION}\""
rm -f Dockerfile