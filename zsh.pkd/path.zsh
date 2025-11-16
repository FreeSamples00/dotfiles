eval "$(/usr/libexec/path_helper)"

alias path='print -c ${(s/:/)PATH} | bat --file-name "\$PATH"'
