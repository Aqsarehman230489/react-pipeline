#!/bin/bash
echo "=== Stopping existing PM2 services ==="

# Stop PM2 processes if running
if command -v pm2 >/dev/null 2>&1; then
    pm2 stop all || true
    pm2 delete all || true
fi

# Kill any processes on port 3000
sudo fuser -k 3000/tcp || true

echo "=== PM2 services stopped ==="