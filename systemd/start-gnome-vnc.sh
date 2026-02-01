#!/bin/bash
set -e

# ---- クリーンアップ ----
pkill -9 Xvfb || true
pkill -9 gnome-session || true
pkill -9 gnome-shell || true
pkill -9 x11vnc || true
pkill -9 websockify || true
rm -f /tmp/.X0-lock || true

# ---- Xvfb 起動 ----
Xvfb :0 -screen 0 1920x1080x24 &
sleep 1

# ---- GNOME セッション起動（拡張無効）----
export GNOME_SHELL_DISABLE_USER_EXTENSIONS=1
sudo -u gnome DISPLAY=:0 gnome-session --session=ubuntu --disable-acceleration-check &
sleep 3

# ---- VNC サーバ ----
x11vnc -display :0 -nopw -forever -shared -noxdamage -noshm -rfbport 5900 &
sleep 1

# ---- noVNC / websockify ----
websockify --web=/usr/share/novnc/ 8080 localhost:5900
