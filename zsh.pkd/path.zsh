eval "$(/usr/libexec/path_helper)"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/Library/Python/3.9/bin"

alias path='print -c ${(s/:/)PATH} | bat --file-name "\$PATH"'
