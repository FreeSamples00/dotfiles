#!/bin/sh -l
export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$HOME/.local/state/nix/profiles/home-manager/home-path/bin:$HOME/.nix-profile/bin:/opt/homebrew/bin:$PATH"
exec nu --experimental-options='native-clip' "$@"
