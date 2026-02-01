#!/bin/bash
set -e

# ---- 環境変数（軽量 GNOME に必須） ----
export DISPLAY=:0
export XDG_RUNTIME_DIR=/run/user/1000
export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
export MUTTER_DEBUG_FORCE_NO_HW=1
export MUTTER_DEBUG_FORCE_NO_GL=1
export LIBGL_ALWAYS_SOFTWARE=1
export MESA_LOADER_DRIVER_OVERRIDE=llvmpipe

# ---- クリーンアップ ----
pkill -9 Xvfb || true
pkill -9 gnome-session || true
pkill -9 gnome-shell || true
pkill -9 x11vnc || true
pkill -9 websockify || true
rm -f /tmp/.X0-lock || true

# ---- Xvfb 起動 ----
Xvfb :0 -screen 0 1920x1080x24 &
sleep 2

# ---- GNOME（軽量モード）起動 ----
sudo -u gnome gnome-session --session=ubuntu --disable-acceleration-check &
sleep 5

# ---- VNC ----
x11vnc -display :0 -forever -nopw -shared &
sleep 2

# ---- noVNC ----
websockify --web=/usr/share/novnc/ 8080 localhost:5900
