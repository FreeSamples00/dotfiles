function play() {
  if ! [[ -f "$1" ]]; then
    echo -e "\033[93mFile not found\033[0m"
    exit 1
  fi

  command nohup mpv "$1" &>/dev/null &

}
compdef _files play
