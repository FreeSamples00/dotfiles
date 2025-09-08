#!/bin/sh

# TODO:
# - use this script to read stored values from /tmp
# - run routinely as reading the stored data is lightweight
# - if values are stale / not taken display red and --

sketchybar \
  --set "$NAME" \
        label="--"

# barebones implementation
sketchybar \
  --set "$NAME" \
        label="$(cd scripts/dexcom_api || exit 1; uv run ./main.py)"

