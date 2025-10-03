#!/bin/bash
# Master startup script for Messaging System

set -e

echo "Starting Messaging System..."

# 1. Start RabbitMQ
echo "  Starting RabbitMQ..."
sudo systemctl enable rabbitmq-server
sudo systemctl start rabbitmq-server
sleep 2

# 2. Activate Python virtual environment
echo "  Activating Python venv..."
source venv/bin/activate

# 3. Kill any old Gunicorn processes
echo "  Killing old Gunicorn processes..."
pkill -f "gunicorn.*app.app:app" || true

# 4. Kill any old Celery workers
echo "  Killing old Celery workers..."
pkill -f "celery.*app.celery_app.celery" || true

# 5. Start Celery Worker
echo "  Starting Celery worker..."
nohup celery -A app.celery_app.celery worker --loglevel=info > logs/celery.log 2>&1 &

# 6. Start Flask app with Gunicorn
echo "  Starting Flask app with Gunicorn..."
nohup gunicorn -w 4 -b 0.0.0.0:5000 app.app:app > logs/gunicorn.log 2>&1 &

# 7. Configure & Restart Nginx
echo "  Restarting Nginx..."
sudo cp nginx/messaging_system.conf /etc/nginx/sites-available/ > /dev/null 2>&1 || true
sudo ln -sf /etc/nginx/sites-available/messaging_system.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# 8. Start Ngrok
echo "  Starting ngrok tunnel..."
nohup ngrok http 5000 > logs/ngrok.log 2>&1 &

# 9. Show status
sleep 5
echo "Messaging System Started!"
echo "-----------------------------------"
echo "Celery logs:    tail -f logs/celery.log"
echo "Gunicorn logs:  tail -f logs/gunicorn.log"
echo "Ngrok logs:     tail -f logs/ngrok.log"
echo "App logs:       tail -f logs/app.log"
echo "-----------------------------------"
echo "Public URL from ngrok:"
grep -o "https://[a-z0-9]*\.ngrok.io" logs/ngrok.log | head -n 1
