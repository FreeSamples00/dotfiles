#!/bin/zsh

# Add this directory to fpath for completion functions
fpath+=("${0:h}")

# Reload completion system to pick up new completions
# This is needed because compinit is called before packages are loaded
autoload -Uz compinit
compinit
