#! /bin/bash

date | tr -d '\n'
echo -en '  --  '

if (($# != 1)); then
  echo "Git sync failed: no args"
  exit 1
fi

if ! [[ -d "$1" ]] || ! [[ -d "$1/.git" ]]; then
  echo "Git sync failed: '$1' is not a git repo"
  exit 1
fi

if ! cd "$1"; then
  echo "Git sync failed: 'cd $1'"
  exit 1
fi

if ! git add . >>/dev/null; then
  echo "Git sync failed: 'git add .'"
  exit 1
fi

if ! git commit -m "Automatic commit from '$HOSTNAME'" >>/dev/null; then
  echo "Git sync failed: 'git commit -m <message>'. Likely no changed files"
  exit 1
fi

if ! git push >>/dev/null; then
  echo "Git sync failed: 'git push'. Likely no network connection"
  exit 1
fi
