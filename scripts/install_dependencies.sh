#!/bin/bash
set -e

# Update system
sudo yum update -y

# Install Node.js (LTS) if not already installed
if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
  yum install -y nodejs gcc-c++ make
fi

# Install PM2 + serve globally
if ! command -v pm2 >/dev/null 2>&1; then npm install -g pm2; fi
if ! command -v serve >/dev/null 2>&1; then npm install -g serve; fi

# Ensure app directory
mkdir -p /var/www/reactapp
chown -R ec2-user:ec2-user /var/www/reactapp

