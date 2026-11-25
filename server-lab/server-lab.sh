#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
COMPOSE_FILE="${SCRIPT_DIR}/docker-compose.yml"
TARGET_URL="http://127.0.0.1:8080"

case "$1" in
  start)
    echo "🚀 server-lab を起動・ビルドしています..."
    docker compose -f "$COMPOSE_FILE" up -d --build
    ;;
  stop)
    echo "🛑 server-lab を停止・削除しています..."
    docker compose -f "$COMPOSE_FILE" down
    ;;
  restart)
    echo "🔄 server-lab を再起動しています..."
    docker compose -f "$COMPOSE_FILE" down && docker compose -f "$COMPOSE_FILE" up -d --build
    ;;
  status)
    docker compose -f "$COMPOSE_FILE" ps
    ;;
  logs)
    docker compose -f "$COMPOSE_FILE" logs -f
    ;;
  reset)
    echo "🧹 アクセスカウンター(Redis)をリセットしています..."
    docker compose -f "$COMPOSE_FILE" exec redis-db redis-cli FLUSHALL
    ;;
  test)
    N=${2:-10000}
    C=${3:-1000}
    echo "🔥 負荷テストを実行します (URL: $TARGET_URL / リクエスト数: $N / 同時接続: $C)..."
    docker run --rm -it --network host --ulimit nofile=65535:65535 ghcr.io/hatoo/oha -n "$N" -c "$C" "$TARGET_URL"
    ;;
  *)
    echo "使い方: server-lab {start|stop|restart|status|logs|reset|test}"
    exit 1
    ;;
esac
