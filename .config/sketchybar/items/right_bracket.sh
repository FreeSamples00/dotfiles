#! /bin/bash

sketchybar \
  --add bracket right_bracket '/.*\.right/' \
  --set right_bracket \
        background.drawing="$BACKGROUND_STATUS" \
        background.color="$BACKGROUND_COLOR" \
        background.height="$BACKGROUND_HEIGHT" \
        background.corner_radius="$BACKGROUND_RADIUS" \
