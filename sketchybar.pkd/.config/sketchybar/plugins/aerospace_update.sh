#!/usr/bin/env bash

source "$CONFIG_DIR/core/env.sh"
source "$CONFIG_DIR/plugins/aerospace.sh"

WS_ID=$1
FOCUSED_WORKSPACE=$(get_aerospace_focused_workspace)
WORKSPACE_STATUS=$(get_aerospace_workspace_status "$WS_ID")

if [ "$WS_ID" = "$FOCUSED_WORKSPACE" ]; then
  LABEL_COLOR="$COLOR_ORANGE"
else
  if [ "$WORKSPACE_STATUS" = "empty" ]; then
    LABEL_COLOR="$COLOR_LIGHT_GRAY"
  else
    LABEL_COLOR="$COLOR_MAGENTA"
  fi
fi

sketchybar --set "$NAME" \
  label.color="$LABEL_COLOR"
