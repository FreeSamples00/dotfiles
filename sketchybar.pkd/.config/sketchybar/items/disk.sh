#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/icon.sh"
source "$CONFIG_DIR/plugins/helpers.sh"

DISK_ICON=$(get_widget_icon "disk")

SIDE="${1:-right}"

sketchybar --add item disk.percent "$SIDE" \
  --set disk.percent \
  label.padding_right="$SBAR_ITEM_LABEL_PADDING_RIGHT" \
  update_freq="$SBAR_ITEM_UPDATE_FREQ_DEFAULT" \
  script="$SBAR_PLUGIN_DIR/disk.sh" \
  \
--add item disk.icon "$SIDE" \
--set disk.icon \
icon="$DISK_ICON" \
icon.font="$SBAR_ICON_FONT_FAMILY:Bold:$SBAR_ICON_FONT_SIZE" \
icon.padding_left="$SBAR_ITEM_ICON_PADDING_LEFT" \
icon.padding_right="$SBAR_ITEM_ICON_PADDING_RIGHT"
