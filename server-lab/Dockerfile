FROM python:3.11-slim

WORKDIR /app
RUN pip install --no-cache-dir flask redis gunicorn gevent
COPY app.py .

CMD ["gunicorn", "-k", "gevent", "-w", "4", "--worker-connections", "1000", "--backlog", "4096", "-b", "0.0.0.0:5000", "app:app"]
