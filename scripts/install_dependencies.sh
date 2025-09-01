#!/bin/bash
set -e

# Ensure basic tools
apt-get update -y
apt-get install -y curl

# Install PM2 + static file server (serve) globally
if ! command -v pm2 >/dev/null 2>&1; then npm install -g pm2; fi
if ! command -v serve >/dev/null 2>&1; then npm install -g serve; fi

# Ensure target directory ownership
mkdir -p /var/www/reactapp
chown -R ubuntu:ubuntu /var/www/reactapp
