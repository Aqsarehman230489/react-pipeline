#!/bin/bash

# A script to log in to Docker Hub, pull the latest image, stop and remove
# any existing container, and start a new one.

# --- Configuration ---
# Set the name of the Docker image to be pulled and run.
IMAGE_NAME="react-app"
IMAGE_TAG="latest"
CONTAINER_NAME="react-app-container"
PORT_MAPPING="3000:3000"

# --- Main Logic ---

# Check if required environment variables are set.
if [ -z "$DOCKERHUB_USERNAME" ]; then
  echo "Error: DOCKERHUB_USERNAME environment variable is not set."
  exit 1
fi

if [ -z "$DOCKERHUB_PASSWORD" ]; then
  echo "Error: DOCKERHUB_PASSWORD environment variable is not set."
  exit 1
fi

echo "=== Logging in to Docker Hub ==="
# Log in to Docker Hub using credentials from environment variables.
# The `echo` command pipes the password to the `docker login` command's standard input,
# which is the recommended and more secure method for non-interactive use.
echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
if [ $? -ne 0 ]; then
  echo "Docker login failed. Check your DOCKERHUB_USERNAME and DOCKERHUB_PASSWORD environment variables."
  # Clear sensitive information from memory
  unset DOCKERHUB_PASSWORD
  exit 1
fi

echo "=== Pulling latest Docker image ==="
# Pull the latest Docker image. The script will fail if the pull fails.
docker pull "$DOCKERHUB_USERNAME/$IMAGE_NAME:$IMAGE_TAG"
if [ $? -ne 0 ]; then
  echo "Docker pull failed. Check the image name and tag."
  unset DOCKERHUB_PASSWORD
  exit 1
fi

echo "=== Stopping and removing any existing containers ==="
# Stop and remove the container if it's already running.
# The '|| true' ensures the script doesn't fail if the container doesn't exist.
docker stop "$CONTAINER_NAME" || true
docker rm "$CONTAINER_NAME" || true

echo "=== Starting new Docker container ==="
# Run the new container. The '-d' flag runs the container in detached mode.
docker run -d \
  --name "$CONTAINER_NAME" \
  -p "$PORT_MAPPING" \
  --restart unless-stopped \
  "$DOCKERHUB_USERNAME/$IMAGE_NAME:$IMAGE_TAG"

if [ $? -ne 0 ]; then
  echo "Docker run failed. This could be due to a port conflict or an issue with the application inside the container."
  unset DOCKERHUB_PASSWORD
  exit 1
fi

echo "=== Docker container started successfully ==="

echo "=== Viewing container logs for debugging ==="
# Print the last 20 lines of the container logs for immediate debugging.
docker logs --tail 20 "$CONTAINER_NAME"

# --- Cleanup ---
# Unset the environment variable containing the password to prevent it from being
# accidentally exposed in the shell environment or history.
unset DOCKERHUB_PASSWORD

echo "=== Deployment script finished ==="
