#!/bin/bash
# Master stop script for Messaging System

echo " Stopping Messaging System..."

# Kill Celery workers
echo " Stopping Celery workers..."
pkill -f "celery -A app.celery_app.celery worker" || true

# Kill Gunicorn
echo " Stopping Gunicorn..."
pkill -f "gunicorn -w" || true

# Kill ngrok
echo "  Stopping ngrok..."
pkill -f "ngrok http" || true

# Nginx can keep running (system service), but you can disable site if needed
# Uncomment below lines if you want to disable the app site on stop
# echo "  Disabling Nginx site..."
# sudo rm -f /etc/nginx/sites-enabled/messaging_system.conf
# sudo systemctl reload nginx

echo " All processes stopped!"
