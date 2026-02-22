# ubuntu-desktop-novnc

echo "$GITHUB_TOKEN" | docker login ghcr.io -u "kk20100522" --password-stdin

docker run -d \
  --privileged \
  --name gnome-desktop \
  --shm-size=4gb \
  --cgroupns host \
  --cpu-shares 1024 \
  --memory-reservation 4g \
  --tmpfs /run --tmpfs /run/lock \
  -e LIBGL_ALWAYS_SOFTWARE=1 \
  -e GALLIUM_DRIVER=llvmpipe \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  -v /workspaces/ubuntu-desktop-novnc/audio:/audio \
  --log-opt max-size=10m --log-opt max-file=3 \
  -p 8080:8080 \
  -p 9000:9000 \
  ghcr.io/kk20100522/gnome-desktop:v14

# サービスの有効化（次回起動時用）
docker exec gnome-desktop systemctl enable gnome-vnc

# サービスの即時開始
docker exec gnome-desktop systemctl start gnome-vnc

docker exec -u 0 gnome-desktop-restored bash -c "echo 'gnome:kk19370912' | chpasswd"

docker exec -it gnome-desktop bash

docker commit gnome-desktop ghcr.io/kk20100522/gnome-desktop:v"バージョン数"
docker push ghcr.io/kk20100522/gnome-desktop:v"バージョン数"

# 音声出力
pulseaudio --start

pactl load-module module-null-sink sink_name=virtual_sink

pactl set-default-sink virtual_sink

node /audio/compare-server.js