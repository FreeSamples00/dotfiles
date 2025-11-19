eval "$(/usr/libexec/path_helper)"
export PATH="$PATH:/Users/scc/.local/bin"

alias path='print -c ${(s/:/)PATH} | bat --file-name "\$PATH"'
