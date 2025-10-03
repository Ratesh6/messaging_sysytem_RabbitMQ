from celery import Celery
import smtplib, logging
from datetime import datetime
from app import config

# Create Celery instance
celery = Celery("tasks", broker=config.BROKER_URL)

@celery.task
def send_email_task(recipient_email):
    """Send email asynchronously via SMTP"""
    try:
        message = "Subject: Test Email\n\nThis is a test email from Celery."
        with smtplib.SMTP(config.SMTP_HOST, config.SMTP_PORT) as server:
            server.starttls()
            server.login(config.SMTP_USER, config.SMTP_PASS)
            server.sendmail(config.SMTP_USER, recipient_email, message)
        return f"Email sent to {recipient_email}"
    except Exception as e:
        return str(e)

@celery.task
def log_time_task():
    """Log current server time into logs/app.log"""
    logging.basicConfig(filename="logs/app.log", level=logging.INFO)
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    logging.info(f"Current time: {now}")
    return f"Time logged: {now}"
