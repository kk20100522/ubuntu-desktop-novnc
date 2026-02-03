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
