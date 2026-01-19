#!/usr/bin/env bash

# Sketchybar environment variables
: "${NAME:=}"
: "${SIDE:=right}"

NAME=$2
SIDE="${1:-right}"

if [ -z "$NAME" ]; then
  return 1
fi

sketchybar --add item "spacer_$NAME" "$SIDE" \
  --set "spacer_$NAME" width=8
