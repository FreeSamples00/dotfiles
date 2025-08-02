#! /bin/bash

# filepaths
STORAGE_DIR="${HOME}/.dotfiles/nondot_configs"
BREW_PATH="${STORAGE_DIR}/Brewfile"
CRON_PATH="${STORAGE_DIR}/Cronjobs"

# dump brewfile
rm "$BREW_PATH"
brew bundle dump --no-vscode --file="$BREW_PATH"

# dump cron jobs
crontab -l >"$CRON_PATH"
