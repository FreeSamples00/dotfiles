#!/usr/bin/env bash

if osascript -e 'output muted of (get volume settings)' | grep "true" >/dev/null; then
  osascript -e 'set volume without output muted'
else
  osascript -e 'set volume with output muted'
fi
