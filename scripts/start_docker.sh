#!/bin/bash
echo "=== Starting Docker container ==="

cd /var/www/reactapp

# Login to Docker Hub (credentials from environment variables)
echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin

# Stop any existing containers
docker stop react-app-container || true
docker rm react-app-container || true

# Pull latest image and run
docker pull $DOCKERHUB_USERNAME/react-app:latest
docker run -d \
  --name react-app-container \
  -p 3000:3000 \
  --restart unless-stopped \
  $DOCKERHUB_USERNAME/react-app:latest

echo "=== Docker container started ==="