#! /bin/bash

if [ "$1" == "$FOCUSED_WORKSPACE" ]; then
    sketchybar \
      --set "$NAME" label.highlight=on
else
    sketchybar \
      --set "$NAME" label.highlight=off
fi

