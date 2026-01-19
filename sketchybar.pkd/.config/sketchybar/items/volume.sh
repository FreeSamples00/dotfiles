#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/icon.sh"
source "$CONFIG_DIR/plugins/helpers.sh"

VOLUME_ICON=$(get_widget_icon "volume_mute")

SIDE="${1:-right}"

sketchybar --add item volume.label "$SIDE" \
  --set volume.label \
  label.padding_right="$SBAR_ITEM_LABEL_PADDING_RIGHT" \
  update_freq=1 \
  script="$SBAR_PLUGIN_DIR/volume.sh" \
  click_script="$SBAR_SCRIPT_DIR/toggle_mute.sh" \
  --subscribe volume.label volume_change \
  \
  --add item volume.icon "$SIDE" \
  --set volume.icon \
  icon="$VOLUME_ICON" \
  icon.font="$SBAR_ICON_FONT_FAMILY:Bold:$(calc "$SBAR_ICON_FONT_SIZE + 4")" \
  click_script="$SBAR_SCRIPT_DIR/toggle_mute.sh" \
  icon.padding_left="$SBAR_ITEM_ICON_PADDING_LEFT" \
  icon.padding_right="$SBAR_ITEM_ICON_PADDING_RIGHT"
