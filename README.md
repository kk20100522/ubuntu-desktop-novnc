# ubuntu-desktop-novnc

echo "$GITHUB_TOKEN" | docker login ghcr.io -u "$GITHUB_USER" --password-stdin

docker run -d \
--privileged \
--name gnome-desktop \
--shm-size=2gb \
--cgroupns host \
--tmpfs /run --tmpfs /run/lock \
-v /sys/fs/cgroup:/sys/fs/cgroup:rw \
-p 8080:8080 \
ghcr.io/kk20100522/gnome-desktop:latest

# サービスの有効化（次回起動時用）
docker exec gnome-desktop systemctl enable gnome-vnc

# サービスの即時開始
docker exec gnome-desktop systemctl start gnome-vnc