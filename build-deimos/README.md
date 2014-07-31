Command to build deimos using one of the Docker build containers:

    docker run -v /${PATH_TO_DEIMOS_CHECKOUT}:/container ${DOCKER_IMAGE_ID}

Note: This does not work on boot2docker environments (OSX) because the volume
mounting is between the Docker VirtualBox VM and the Docker container, not the
OSX host.
