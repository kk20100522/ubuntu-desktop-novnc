#!/bin/bash
set -e

export DISPLAY=:0
export XDG_RUNTIME_DIR=/run/user/1000
export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
export MUTTER_DEBUG_FORCE_NO_HW=1
export MUTTER_DEBUG_FORCE_NO_GL=1

# Xvfb 起動
Xvfb :0 -screen 0 1024x576x24 &
sleep 2

# GNOME セッション起動（gnome ユーザーで）
sudo -u gnome bash -c 'gnome-session --session=ubuntu --disable-acceleration-check' &
sleep 5

# VNC サーバー起動
x11vnc -display :0 -forever -nopw -shared \
  -quality 6 \
  -encodings tight \
  -fps 30 \
  -noxdamage \
  -nocursorshape \
  -ncache 10 &

sleep 2

# noVNC 起動
websockify --web=/usr/share/novnc/ 8080 localhost:5900
