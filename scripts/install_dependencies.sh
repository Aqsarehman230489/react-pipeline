#!/bin/bash
set -e

echo "=== Installing Docker on Amazon Linux ==="

# Update the system to get the latest package information
sudo dnf update -y

# Install Docker
sudo dnf install -y docker

# Start the Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add ec2-user to docker group
sudo usermod -a -G docker ec2-user

# Install Docker Compose
# Docker Compose is now officially a plugin for Docker and uses a different install method
# The method below is for the standalone v2.x version
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "=== Docker setup completed ==="