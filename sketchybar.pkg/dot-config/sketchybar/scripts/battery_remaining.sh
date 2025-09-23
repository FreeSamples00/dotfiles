#!/bin/bash

# script

sketchybar \
  --set "$NAME" \
    label="--:--"

TIME_REMAINING=$(pmset -g batt + grep 'remaining' | awk -F';' '{print $3}' | awk -F' ' '{print $1}' | xargs)

if ( echo "$TIME_REMAINING" | grep "^\d:\d\d$" >/dev/null ); then
  sketchybar \
    --set "$NAME" \
          label="$TIME_REMAINING"
fi
