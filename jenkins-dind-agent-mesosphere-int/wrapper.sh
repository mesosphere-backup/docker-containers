#!/bin/bash
set -e

echo "==> Launching the Docker daemon..."
dind docker daemon --host=unix:///var/run/docker.sock --storage-driver=overlay &

while(! docker info > /dev/null 2>&1); do
    echo "==> Waiting for the Docker daemon to come online..."
    sleep 1
done
echo "==> Docker Daemon is up and running!"

/bin/sh -c "$@"
