# brew setup
if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]] then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  config_err "LinuxBrew path '/home/linuxbrew/.linxbrew/bin/brew' not found"
fi

# OS specific shorthands
alias ofd="$LINUX_FILE_MANAGER ."
alias copy='xclip -selection clipboard -i'
alias paste='xclip -selection clipboard -o'
