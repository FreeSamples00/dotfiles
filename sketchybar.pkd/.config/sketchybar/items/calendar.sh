#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/icon.sh"

CALENDAR_ICON=$(get_widget_icon "calendar")

sketchybar --add item calendar.label right \
  --set calendar.label \
  label.padding_right="$SBAR_ITEM_LABEL_PADDING_RIGHT" \
  update_freq=10 \
  script="$SBAR_PLUGIN_DIR/calendar.sh"

sketchybar --add item calendar.icon right \
  --set calendar.icon \
  icon="$CALENDAR_ICON" \
  icon.font="$SBAR_ICON_FONT_FAMILY:Bold:$SBAR_ICON_FONT_SIZE" \
  icon.padding_left="$SBAR_ITEM_ICON_PADDING_LEFT" \
  icon.padding_right="$SBAR_ITEM_ICON_PADDING_RIGHT"
