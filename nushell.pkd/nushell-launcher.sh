#!/bin/bash
export XDG_CONFIG_HOME="$HOME/.config"
export PATH="/opt/homebrew/bin:$PATH"
exec nu "$@"
