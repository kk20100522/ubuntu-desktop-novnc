#!/bin/bash

# 1. ディスクのマウント
sudo mkdir -p /mnt/bigdata
if ! mountpoint -q /mnt/bigdata; then
    sudo mount /dev/sda1 /mnt/bigdata
fi

# 2. 保存先ディレクトリの準備
sudo mkdir -p /mnt/bigdata/docker
sudo mkdir -p /etc/docker

# 3. 設定ファイルの作成
sudo tee /etc/docker/daemon.json <<DOCKERCONF
{
  "data-root": "/mnt/bigdata/docker"
}
DOCKERCONF

# 4. 【重要】標準のDockerが落ち着くまで待つ
echo "Waiting for default docker to settle..."
sleep 10

# 5. プロセスを確実に掃除
sudo pkill -9 dockerd || true
sudo pkill -9 containerd || true
sleep 5

# 6. 新しい設定で再起動
echo "Starting Docker with bigdata root..."
sudo nohup dockerd > /tmp/dockerd.log 2>&1 &

# 7. 起動完了を待つ
for i in {1..10}; do
    if docker info >/dev/null 2>&1; then
        echo "Docker is ready at /mnt/bigdata/docker"
        exit 0
    fi
    sleep 2
done

echo "Docker start failed. Check /tmp/dockerd.log"
