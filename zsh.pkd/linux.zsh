# brew setup
if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]] then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  ERROR_STATUS="$ERROR_STATUS\n\tLinuxBrew path '/home/linuxbrew/.linxbrew/bin/brew' not found(line ${LINENO})"
fi

# OS specific shorthands
alias ofd="$LINUX_FILE_MANAGER ."
alias copy='xclip -selection clipboard -i'
alias paste='xclip -selection clipboard -o'
