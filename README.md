# ubuntu-desktop-novnc

echo "$GITHUB_TOKEN" | docker login ghcr.io -u "kk20100522" --password-stdin

 docker run -d \
  --privileged \
  --name gnome-desktop \
  --shm-size=2gb \
  --cgroupns host \
  --tmpfs /run --tmpfs /run/lock \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  -v /workspaces/ubuntu-desktop-novnc/audio:/audio \
  -p 8080:8080 \
  -p 9000:9000 \
  ghcr.io/kk20100522/gnome-desktop:v4

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

(venv) gnome@4f64c9fe9292:~$ pip install pygame
Requirement already satisfied: pygame in ./venv/lib/python3.12/site-packages (2.6.1)

(venv) gnome@4f64c9fe9292:~$ pip --version
pip 24.0 from /home/gnome/venv/lib/python3.12/site-packages/pip (python 3.12)
(venv) gnome@4f64c9fe9292:~$ pip install pygame
Requirement already satisfied: pygame in ./venv/lib/python3.12/site-packages (2.6.1)
(venv) gnome@4f64c9fe9292:~$ 