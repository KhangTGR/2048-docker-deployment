#!/bin/bash

# Description:
# This script sets up a Jenkins environment within a Docker container with Docker-in-Docker support.
# It creates a Docker network, starts a Docker daemon, builds a Jenkins Docker image, and runs Jenkins with Blue Ocean.

# Create a Docker network for Jenkins
docker network create jenkins

# Start a Docker daemon with Docker-in-Docker support
docker run \
    --name jenkins-docker \
    --rm \
    --detach \
    --privileged \
    --network jenkins \
    --network-alias docker \
    --env DOCKER_TLS_CERTDIR=/certs \
    --volume jenkins-docker-certs:/certs/client \
    --volume jenkins-data:/var/jenkins_home \
    --publish 2376:2376 \
    docker:dind \
    --storage-driver overlay2

# Build the Jenkins Docker image with Blue Ocean
cd dockerfiles
docker build -t myjenkins-blueocean:latest - <BlueOcean.Dockerfile

# Run Jenkins with Blue Ocean
docker run \
    --name jenkins-blueocean \
    --restart=on-failure \
    --detach \
    --network jenkins \
    --env DOCKER_HOST=tcp://docker:2376 \
    --env DOCKER_CERT_PATH=/certs/client \
    --env DOCKER_TLS_VERIFY=1 \
    --publish 8080:8080 \
    --publish 50000:50000 \
    --volume jenkins-data:/var/jenkins_home \
    --volume jenkins-docker-certs:/certs/client:ro \
    myjenkins-blueocean:latest
