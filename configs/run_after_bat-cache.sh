#!/bin/sh
if command -v bat >/dev/null 2>&1; then
  bat cache --build
fi
