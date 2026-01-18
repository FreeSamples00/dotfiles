#!/usr/bin/env bash

source "$CONFIG_DIR/core/env.sh"
source "$CONFIG_DIR/tokens/colors.sh"
source "$CONFIG_DIR/plugins/icon.sh"

PID_FILE="/tmp/sketchybar_caffeinate.pid"

if [ -f "$PID_FILE" ]; then
  PID=$(cat "$PID_FILE")
  if kill -0 "$PID" 2>/dev/null && ps -p "$PID" -o comm= | grep -q "caffeinate"; then
    ICON=$(get_widget_icon "coffee_off")
    ICON_COLOR="$SBAR_COLOR_CAFFEINATE_ON"
  else
    rm "$PID_FILE"
    ICON=$(get_widget_icon "coffee_on")
    ICON_COLOR="$SBAR_COLOR_CAFFEINATE"
  fi
else
  ICON=$(get_widget_icon "coffee_on")
  ICON_COLOR="$SBAR_COLOR_CAFFEINATE"
fi

if [ "$SBAR_BAR_STYLE" = "compact" ]; then
  sketchybar --set caffeinate.icon icon="$ICON" icon.color="$ICON_COLOR"
else
  sketchybar --set caffeinate.icon icon="$ICON" icon.color="$ICON_COLOR"
fi
