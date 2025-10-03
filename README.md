Messaging System — RabbitMQ + Celery + Nginx + Python
Project Overview

This project demonstrates a messaging system using RabbitMQ as a message broker and Celery as a task queue, with a Python web application served behind Nginx. The system provides endpoints for sending emails asynchronously and logging server time.

Components

Nginx: Reverse proxy routing requests to the Python app.

Gunicorn/Uvicorn: Runs the Flask or FastAPI web application.

RabbitMQ: Message broker for task queuing.

Celery Workers: Execute email sending and optional logging tasks.

SMTP Server: Handles sending emails.

ngrok: Exposes the local server for external testing.

Email Sending (?sendmail)

Accepts an email address as a parameter.

Publishes a task to RabbitMQ.

Celery worker sends the email asynchronously.

Logging Time (?talktome)

Logs the current server timestamp to a log file.

Demonstrates synchronous logging functionality.

Can optionally be configured as a Celery task.

Task Execution

Email tasks are asynchronous.

Logging tasks are synchronous but can be asynchronous if needed.

Testing Procedure

Access endpoints via ngrok:

/action?sendmail=test@example.com → sends email asynchronously.

/action?talktome → logs current time.

Verify:

Email delivery.

Log file updates.

Celery worker executes tasks.

Conclusion

This project demonstrates asynchronous task processing with RabbitMQ and Celery, with a Python web interface through Nginx. External testers can validate email-sending and logging functionality via ngrok, simulating production-ready patterns like task queuing, reverse proxying, and background job execution.
