#! /bin/bash

sketchybar \
  --add bracket left_bracket '/.*\.left/' \
  --set left_bracket \
        background.drawing="$BACKGROUND_STATUS" \
        background.color="$BACKGROUND_COLOR" \
        background.height="$BACKGROUND_HEIGHT" \
        background.corner_radius="$BACKGROUND_RADIUS" \
