eval "$(/usr/libexec/path_helper)"

# Prioritize Homebrew binaries (for FIDO2 support in OpenSSH)
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/Library/Python/3.9/bin"

alias path='print -c ${(s/:/)PATH} | bat --file-name "\$PATH"'
