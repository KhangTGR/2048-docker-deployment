#!/bin/bash

# Define the name of the Docker container
CONTAINER_NAME="docker-2048-gameserver-container"

# Check if the Docker container exists
if docker ps -a --format '{{.Names}}' | grep -Eq "^$CONTAINER_NAME$"; then
  # Container exists, so stop and remove it
  docker stop "$CONTAINER_NAME"
  docker rm "$CONTAINER_NAME"
fi

# Build a Docker image for Docker 2048 GameServer
cd dockerfiles
docker build -t docker-2048-gameserver-image:latest - <2048Game.Dockerfile

# Run 2048 game in Docker container
docker run --name "$CONTAINER_NAME" -d -p 80:80 docker-2048-gameserver-image:latest
