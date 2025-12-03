#!/bin/bash
# script

CONNECTION_TYPE=$("$CONFIG_DIR/scripts/connection_type.sh")

HIGHLIGHT="off"

case $CONNECTION_TYPE in
  wifi)
    ICON="󰖩"
    ;;
  ethernet)
    ICON="󰈀"
    ;;
  hotspot)
    ICON=""
    ;;
  offline)
    ICON="󰖪"
    HIGHLIGHT="on"
    ;;
  *)
    ICON="󱚵"
    HIGHLIGHT="on"
    ;;
esac

sketchybar \
  --set "$NAME" \
        icon="$ICON" \
        icon.highlight="$HIGHLIGHT" \
        label.padding_left=0 \
        label.padding_right=0 \
        icon.padding_left=0 \
        icon.padding_right=0
