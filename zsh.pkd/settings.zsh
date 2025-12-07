# ==================== SETTINGS ====================

DO_SPLASH_SCREEN=1

USE_ENHANCED_CLEAR=1

if (which nvim >/dev/null); then
  export EDITOR="nvim"
  export VISUAL="nvim"
else
  export EDITOR="vim"
  export VISUAL="vim"
fi

if (which neovide >/dev/null); then
  export GUI_EDITOR="neovide"
fi

if (which bat >/dev/null); then
  export PAGER="bat --paging=always -p"
else
  export PAGER="less -R"
fi

LINUX_FILE_MANAGER="xdg-open"

ERROR_STATUS=""

alias echo='echo -e'

set zle_bracketed_paste

setopt IGNORE_EOF # prevent shell from exiting upon EOF
