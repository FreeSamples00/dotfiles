#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/helpers.sh"

SIDE="${1:-right}"

sketchybar --add item battery.percent "$SIDE" \
  --set battery.percent \
  label.padding_right="$SBAR_ITEM_LABEL_PADDING_RIGHT" \
  update_freq="$SBAR_ITEM_UPDATE_FREQ_FAST" \
  script="$SBAR_PLUGIN_DIR/battery.sh" \
  --subscribe battery.percent system_woke power_source_change \
  \
  --add item battery.icon "$SIDE" \
  --set battery.icon \
  icon.font="$SBAR_ICON_FONT_FAMILY:Bold:$(calc "$SBAR_ICON_FONT_SIZE + 4")" \
  icon.padding_left="$SBAR_ITEM_ICON_PADDING_LEFT" \
  icon.padding_right="$SBAR_ITEM_ICON_PADDING_RIGHT"

battery.percent battery.icon
