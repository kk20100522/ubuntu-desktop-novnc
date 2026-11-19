FROM python:3.11-slim

WORKDIR /app
RUN pip install --no-cache-dir flask redis gunicorn
COPY app.py .

# 本番用サーバーGunicorn（4ワーカー並列）で起動
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
