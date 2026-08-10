#!/bin/sh -l
export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$HOME/.nix-profile/bin:/opt/homebrew/bin:$PATH"
exec nu --experimental-options='native-clip' "$@"
