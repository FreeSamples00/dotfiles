#!/bin/bash

if [[ "$1" == "" || "$1" == "-h" || "$1" == "--help" ]]; then
  echo -e "Needs command:\n"
  echo -e "\ttest: dry run"
  echo -e "\tlink: apply links"
  echo -e "\tunlink: delete all links"
  exit 1
elif [[ "$1" == "test" ]]; then
  stow -nv *.pkg
elif [[ "$1" == "link" ]]; then
  stow -v *.pkg
elif [[ "$1" == "unlink" ]]; then
  stow -Dv *.pkg
else
  echo "Command '$1' not found"
  exit 1
fi
