from flask import Flask
import redis
import socket

app = Flask(__name__)
cache = redis.Redis(host='redis-db', port=6379)

@app.route('/')
def index():
    count = cache.incr('cnt')
    hostname = socket.gethostname()
    return f"""
    <h1>✅ Dockerfile構成で稼働中！</h1>
    <p><b>アクセス数:</b> {count}</p>
    <p><b>応答サーバーID:</b> {hostname}</p>
    """
