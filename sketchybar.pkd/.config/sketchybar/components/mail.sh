#!/bin/bash
# components

SIDE="$1"
NAME="mail.$SIDE"
REFRESH_INTERVAL=120

sketchybar \
  --add item "$NAME" "$SIDE" \
  --set "$NAME" \
        update_freq="$REFRESH_INTERVAL" \
        script="$SCRIPT_DIR/mail.sh" \
        click_script="open -a mail"  \
        icon="󰶈" \
        label="--"
