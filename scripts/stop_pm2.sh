#!/bin/bash
set -e
if command -v pm2 >/dev/null 2>&1; then
  pm2 delete reactapp || true
  pm2 stop reactapp || true
fi
