#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
SBAR_PLUGIN_DIR="$CONFIG_DIR/plugins"

source "$CONFIG_DIR/core/env.sh"
source "$SBAR_PLUGIN_DIR/aerospace.sh"

sketchybar --add event aerospace_workspace_change

SIDE="${1:-left}"

workspaces=$(get_aerospace_workspaces)
focused_workspace=$(get_aerospace_focused_workspace)

sketchybar --add item "workspace_bracket_left" "$SIDE" \
  --set workspace_bracket_left \
  label="" \
  label.color="$COLOR_BLACK" \
  label.font="$SBAR_LABEL_FONT_FAMILY:$SBAR_LABEL_FONT_STYLE:$SBAR_LABEL_FONT_SIZE" \
  label.padding_right="$SBAR_ITEM_LABEL_PADDING_RIGHT" \

for sid in $workspaces; do
  CLICK_SCRIPT=$(get_aerospace_workspace_click_command "$sid")
  WORKSPACE_STATUS=$(get_aerospace_workspace_status "$sid")

  sketchybar --add item "workspace_$sid" "$SIDE" \
    --set "workspace_$sid" \
    label="$sid" \
    label.color="$COLOR_BLACK" \
    label.font="$SBAR_LABEL_FONT_FAMILY:$SBAR_LABEL_FONT_STYLE:$SBAR_LABEL_FONT_SIZE" \
    label.padding_left="$SBAR_ITEM_LABEL_PADDING_LEFT" \
    label.padding_right="$SBAR_ITEM_LABEL_PADDING_RIGHT" \
    update_freq=2 \
    script="$SBAR_PLUGIN_DIR/aerospace_update.sh $sid" \
    click_script="$CLICK_SCRIPT" \
    --subscribe "workspace_$sid" aerospace_workspace_change front_app_switched
done

sketchybar --add item "workspace_bracket_right" "$SIDE" \
  --set workspace_bracket_right \
  label="" \
  label.color="$COLOR_BLACK" \
  label.font="$SBAR_LABEL_FONT_FAMILY:$SBAR_LABEL_FONT_STYLE:$SBAR_LABEL_FONT_SIZE" \
  label.padding_left=-2 \
  label.padding_right=5 \

sketchybar --trigger aerospace_workspace_change
