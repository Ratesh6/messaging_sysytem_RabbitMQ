from flask import Flask, request
import logging
from app.celery_app import send_email_task, log_time_task

# Logging setup
logging.basicConfig(
    filename='logs/app.log',
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

app = Flask(__name__)

@app.route("/action")
def action():
    email = request.args.get("sendmail")
    if email:
        logging.info(f"Received sendmail request: {email}")
        send_email_task.delay(email)
        return f"Email task queued for {email}"

    if "talktome" in request.args:
        logging.info("Received talktome request")
        log_time_task.delay()
        return "Current time logged!"

    logging.warning("Invalid request received")
    return "Invalid request. Use ?sendmail=<email> or ?talktome", 400
