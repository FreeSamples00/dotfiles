#!/bin/sh
if command -v fc-cache >/dev/null 2>&1; then
  fc-cache -rf
fi
