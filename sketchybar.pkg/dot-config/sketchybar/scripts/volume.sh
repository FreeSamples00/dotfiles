#!/bin/sh
# script

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

HIGH=""
MEDIUM=""
LOW=""
MUTE=""

# HIGH="󰕾"
# MEDIUM="󰖀"
# LOW="󰕿"
# MUTE="󰖁"

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"

  case "$VOLUME" in
    [6-9][0-9]|100) ICON="$HIGH"
    ;;
    [3-5][0-9]) ICON="$MEDIUM"
    ;;
    [1-9]|[1-2][0-9]) ICON="$LOW"
    ;;
    *) ICON="$MUTE"
  esac

  sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%"
fi
