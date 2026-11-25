from flask import Flask
import redis
from redis.backoff import ExponentialBackoff
from redis.retry import Retry
import socket

app = Flask(__name__)
retry = Retry(ExponentialBackoff(cap=0.5, base=0.01), 3)
pool = redis.ConnectionPool(
    host='redis-db',
    port=6379,
    max_connections=2000,
    retry=retry,
    retry_on_timeout=True
)
cache = redis.Redis(connection_pool=pool)

@app.route('/')
def index():
    count = cache.incr('cnt')
    hostname = socket.gethostname()
    return f"""
    <h1>✅ Dockerfile構成で稼働中！</h1>
    <p><b>アクセス数:</b> {count}</p>
    <p><b>応答サーバーID:</b> {hostname}</p>
    """
