#!/bin/bash
set -e

# Serve the static React build via PM2 on port 3000
pm2 delete reactapp || true
pm2 serve /var/www/reactapp 3000 --name reactapp --spa
pm2 save

# Make PM2 resurrect on reboot
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u ec2-user --hp /home/ec2-user >/dev/null 2>&1 || true

