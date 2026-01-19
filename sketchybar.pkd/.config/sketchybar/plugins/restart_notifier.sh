#!/usr/bin/env bash

source "$CONFIG_DIR/core/env.sh"
source "$CONFIG_DIR/user.sketchybarrc"

THRESHOLD=604800

CURR_TIME=$(date '+%s')
BOOT_TIME=$(sysctl -n kern.boottime | awk -F '[ ,]' '{print $4}')
ELAPSED=$(( CURR_TIME - BOOT_TIME ))

if (( ELAPSED >= THRESHOLD )); then
  sketchybar "${ANIMATION[@]}" --set restart_notifier.icon drawing=on
else
  sketchybar "${ANIMATION[@]}" --set restart_notifier.icon drawing=off
fi
