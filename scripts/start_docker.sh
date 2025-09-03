#!/bin/bash

# This script now securely fetches the Docker Hub credentials from
# AWS Systems Manager Parameter Store before logging in.

# Function to get a parameter from AWS Systems Manager Parameter Store
# The --with-decryption flag is necessary for SecureString parameters.
get_secret() {
  aws ssm get-parameter --name "$1" --with-decryption --query "Parameter.Value" --output text
}

echo "Starting Docker containers..."

# Fetch credentials from Parameter Store using the names you created.
DOCKERHUB_USERNAME=$(get_secret "/codebuild/dockerhub/username")
DOCKERHUB_PASSWORD=$(get_secret "/codebuild/dockerhub/password")

if [ -z "$DOCKERHUB_USERNAME" ] || [ -z "$DOCKERHUB_PASSWORD" ]; then
  echo "Error: Unable to retrieve Docker Hub credentials from AWS Systems Manager."
  exit 1
fi

# Log in to Docker Hub using the fetched credentials
echo "$DOCKERHUB_PASSWORD" | docker login --username "$DOCKERHUB_USERNAME" --password-stdin

# Navigate to the application directory
cd /var/www/reactapp

# Pull the latest images and start the containers
# The --force-recreate flag ensures a fresh container is created
docker-compose down
docker-compose pull
docker-compose up -d --force-recreate

echo "Docker containers started successfully."
