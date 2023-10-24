#!/bin/bash

# Description:
# This script stops and removes Docker containers and images related to a Jenkins environment.
# It cleans up resources created by the jenkins-setup.sh script.

# Stop and remove Jenkins Blue Ocean container
docker stop jenkins-blueocean
docker rm jenkins-blueocean

# Remove Jenkins Blue Ocean Docker image
docker rmi jenkins-blueocean

# Stop and remove Jenkins Docker-in-Docker container
docker stop jenkins-docker
docker rmi jenkins-docker

# Remove Jenkins Docker network
docker network rm jenkins
