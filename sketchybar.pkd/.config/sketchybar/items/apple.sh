#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/icon.sh"
source "$CONFIG_DIR/core/env.sh"

APPLE_ICON=$(get_widget_icon "apple_logo")

SIDE="${1:-left}"

sketchybar --add item apple.icon "$SIDE" \
  --set apple.icon \
  icon="$APPLE_ICON" \
  icon.font="$SBAR_ICON_FONT_FAMILY:Bold:$SBAR_ICON_FONT_SIZE" \
  icon.padding_left="$SBAR_ITEM_ICON_PADDING_LEFT" \
  icon.padding_right="$SBAR_ITEM_ICON_PADDING_RIGHT" \
  padding_right=2
