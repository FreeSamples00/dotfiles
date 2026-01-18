#!/usr/bin/env bash

if [ -n "$SBAR_WIDGETS_LEFT_ENABLED" ]; then
  read -ra SBAR_WIDGETS_LEFT <<< "$SBAR_WIDGETS_LEFT_ENABLED"
else
  export SBAR_WIDGETS_LEFT=(
    "aerospace"
    "front_app"
    "restart_notifier"
  )
fi

if [ -n "$SBAR_WIDGETS_CENTER_ENABLED" ]; then
  read -ra SBAR_WIDGETS_CENTER <<< "$SBAR_WIDGETS_CENTER_ENABLED"
else
  export SBAR_WIDGETS_CENTER=(
  )
fi

if [ -n "$SBAR_WIDGETS_RIGHT_ENABLED" ]; then
  read -ra SBAR_WIDGETS_RIGHT <<< "$SBAR_WIDGETS_RIGHT_ENABLED"
else
  export SBAR_WIDGETS_RIGHT=(
    "clock"
    "weather"
    "caffeinate"
    "volume"
    "battery"
    "disk"
    "ram"
    "cpu"
    "kakaotalk"
  )
fi

export SBAR_AUTO_INSERT_SPACER=true
