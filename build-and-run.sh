#!/usr/bin/env bash

# Test script to check if the Dockerfile is working and bot is able to run

set -e

IMAGE_NAME="discord-bot-v2-godot-image"
CONTAINER_NAME="discord-bot-v2-godot"

# Build the Docker image (uses Dockerfile in current directory)
echo "Building image: ${IMAGE_NAME}..."
docker build -t "${IMAGE_NAME}" .

# Stop and remove any existing container with the same name
if [ "$(docker ps -aq -f name=^${CONTAINER_NAME}$)" ]; then
  echo "Removing existing container: ${CONTAINER_NAME}..."
  docker rm -f "${CONTAINER_NAME}" >/dev/null 2>&1 || true
fi

# Run the container
echo "Running container (Ctrl+C to stop, container will exit): ${CONTAINER_NAME}"
docker run --rm --name "${CONTAINER_NAME}" \
  -it \
  "${IMAGE_NAME}"