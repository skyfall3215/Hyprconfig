#!/bin/bash

# Hyprland klavye düzeni değişimini takip edip Waybar'a sinyal gönderir

PIDFILE="/tmp/hypr-kb-monitor.pid"

# Önceki örneği öldür
if [ -f "$PIDFILE" ]; then
  kill -9 $(cat "$PIDFILE") 2>/dev/null || true
  rm "$PIDFILE"
fi

echo $$ > "$PIDFILE"
trap "rm -f $PIDFILE" EXIT

# İlk durumu al
previous=""

while true; do
  current=$(hyprctl getoption input:kb_layout | grep '^str:' | awk '{print $2}' | tr -d '"')
  
  if [ "$current" != "$previous" ]; then
    previous="$current"
    echo "Klavye düzeni değişti: $current"
    pkill -RTMIN+1 waybar
  fi

  sleep 0.5
done
