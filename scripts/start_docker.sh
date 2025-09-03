#!/bin/bash

# Log in to Docker Hub using credentials from environment variables.
echo "=== Logging in to Docker Hub ==="
echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
if [ $? -ne 0 ]; then
  echo "Docker login failed. Check your DOCKERHUB_USERNAME and DOCKERHUB_PASSWORD environment variables."
  exit 1
fi

echo "=== Pulling latest Docker image ==="
# Pull the latest Docker image. The script will fail if the pull fails.
docker pull "$DOCKERHUB_USERNAME/react-app:latest"
if [ $? -ne 0 ]; then
  echo "Docker pull failed. Check the image name and tag."
  exit 1
fi

echo "=== Stopping and removing any existing containers ==="
# Stop and remove the container if it's already running.
# The '|| true' ensures the script doesn't fail if the container doesn't exist.
docker stop react-app-container || true
docker rm react-app-container || true

echo "=== Starting new Docker container ==="
# Run the new container. The '-d' flag runs the container in detached mode.
docker run -d \
  --name react-app-container \
  -p 3000:3000 \
  --restart unless-stopped \
  "$DOCKERHUB_USERNAME/react-app:latest"

if [ $? -ne 0 ]; then
  echo "Docker run failed. This could be due to a port conflict or an issue with the application inside the container."
  exit 1
fi

echo "=== Docker container started successfully ==="

echo "=== Check container status ==="
# Check the status of the container.
docker ps -a --filter "name=react-app-container" --format "{{.Status}}"
if [ $? -ne 0 ]; then
  echo "Failed to check container status."
  exit 1
fi

echo "=== Viewing container logs for debugging ==="
# Print the last 20 lines of the container logs for immediate debugging.
docker logs --tail 20 react-app-container
