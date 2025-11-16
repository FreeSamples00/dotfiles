#!/bin/bash

if [[ "$1" == "-R" ]]; then
  osascript -e 'tell application "loginwindow" to «event aevtrrst»'
  exit 0
fi

THRESHOLD=604800

CURR_TIME=$(gdate '+%s')
BOOT_TIME=$(sysctl -n kern.boottime | awk -F '[ ,]' '{print $4}')
ELAPSED=$(( CURR_TIME - BOOT_TIME ))

if (( ELAPSED >= THRESHOLD )); then
  sketchybar \
    --set "$NAME" \
          icon="" \
          icon.padding_left=12 \
          icon.padding_right=12
else
  sketchybar \
    --set "$NAME" \
          icon="" \
          icon.padding_left=0 \
          icon.padding_right=0
fi

