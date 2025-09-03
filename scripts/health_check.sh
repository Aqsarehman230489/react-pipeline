#!/bin/bash
echo "=== Health check for Docker container ==="

# Check if container is running
if ! docker ps --filter "name=react-app-container" --format "{{.Names}}" | grep -q "react-app-container"; then
    echo "Container is not running"
    exit 1
fi

# Check container health
CONTAINER_STATUS=$(docker inspect -f '{{.State.Status}}' react-app-container 2>/dev/null)

if [ "$CONTAINER_STATUS" != "running" ]; then
    echo "Container status: $CONTAINER_STATUS"
    docker logs react-app-container
    exit 1
fi

# Check HTTP response
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000)
if [ "$response" -eq 200 ]; then
    echo "Health check passed - HTTP 200"
    exit 0
else
    echo " Health check failed - HTTP $response"
    docker logs react-app-container
    exit 1
fi