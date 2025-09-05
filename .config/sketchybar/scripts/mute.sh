#!/bin/sh

if osascript -e 'output muted of (get volume settings)' | grep "true"; then
  osascript -e 'set volume without output muted'
  echo "Unmuted"
else
  osascript -e 'set volume with output muted'
  echo "Muted"
fi
