#!/bin/sh

SIDE="$1"
NAME="mail.$SIDE"

sketchybar \
  --add item "$NAME" "$SIDE" \
  --set "$NAME" \
        update_freq=120 \
        script="$SCRIPT_DIR/mail.sh" \
        click_script="open -a mail"  \
        icon="󰶈" \
        label="NULL"

