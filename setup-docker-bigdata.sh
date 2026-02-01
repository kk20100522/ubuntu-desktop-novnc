#!/bin/bash

# 1. ディスクのマウント
sudo mkdir -p /mnt/bigdata
if ! mountpoint -q /mnt/bigdata; then
    # マウントに失敗してもループしないよう || true を付与
    sudo mount /dev/sda1 /mnt/bigdata || echo "Mount failed, maybe already mounted"
fi

# 2. 保存先ディレクトリの準備
sudo mkdir -p /mnt/bigdata/docker
sudo mkdir -p /etc/docker

# 3. 設定ファイルの作成（既存の設定があれば上書き）
sudo tee /etc/docker/daemon.json <<DOCKERCONF
{
  "data-root": "/mnt/bigdata/docker"
}
DOCKERCONF

# 4. 安定するまで待機（ここを15秒に。Codespacesの裏側の動きと喧嘩しないため）
echo "Waiting for Codespaces initialization (15s)..."
sleep 15

# 5. 二重起動を防ぐために、古いDockerプロセスを「完全に」掃除
echo "Cleaning up existing Docker processes..."
sudo pkill -15 dockerd || true
sudo pkill -15 containerd || true
sleep 3
sudo pkill -9 dockerd || true
sudo pkill -9 containerd || true
sleep 2

# 6. 古いログを消去して、新しい設定で再起動
sudo rm -f /tmp/dockerd.log
echo "Starting Docker with bigdata root..."
# --iptables=false などを付けなくても、今の環境ならこれでOK
sudo nohup dockerd > /tmp/dockerd.log 2>&1 &

# 7. 起動完了を粘り強く待つ（最大30秒）
echo "Checking Docker status..."
for i in {1..15}; do
    if sudo docker info >/dev/null 2>&1; then
        echo "✅ Success! Docker is ready at /mnt/bigdata/docker"
        exit 0
    fi
    echo "Wait for Docker... ($i)"
    sleep 2
done

echo "❌ Docker start failed. Logs:"
tail -n 20 /tmp/dockerd.log
