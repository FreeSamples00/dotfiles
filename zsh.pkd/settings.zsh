# ==================== SETTINGS ====================

DO_SPLASH_SCREEN=1

USE_ENHANCED_CLEAR=1

if (( $+commands[nvim] )); then
  export EDITOR="nvim"
  export VISUAL="nvim"
else
  export EDITOR="vim"
  export VISUAL="vim"
fi

if (( $+commands[neovide] )); then
  export GUI_EDITOR="neovide"
fi

export PAGER='less -R'

LINUX_FILE_MANAGER="xdg-open"

ERROR_STATUS=""

alias echo='echo -e'

set zle_bracketed_paste

setopt IGNORE_EOF # prevent shell from exiting upon EOF
