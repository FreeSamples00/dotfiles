#!/usr/bin/env bash

source "$CONFIG_DIR/core/env.sh"

if [[ "$1" == "-R" ]]; then
  osascript -e 'tell application "loginwindow" to «event aevtrrst»'
  exit 0
fi

THRESHOLD=604800

CURR_TIME=$(date '+%s')
BOOT_TIME=$(sysctl -n kern.boottime | awk -F '[ ,]' '{print $4}')
ELAPSED=$(( CURR_TIME - BOOT_TIME ))

if (( ELAPSED >= THRESHOLD )); then
  sketchybar --set restart_notifier.icon drawing=on
else
  sketchybar --set restart_notifier.icon drawing=off
fi
