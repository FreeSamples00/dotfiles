# ==================== ZINIT ====================

# Set zinit directory.
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if not present.
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source Zinit.
source "${ZINIT_HOME}/zinit.zsh"

# zinit wrapper w/ error 'handling'
function zinit_safe() {
  zinit "$@"
  if (( status != 0 )); then
    ERROR_STATUS="$ERROR_STATUS\n\tZinit $1 failed for '$2' (line: ${LINENO})"
  fi
}

# ==================== IMMEDIATE LOADS ====================
# Critical for tab completion - must load before first command

zinit_safe light zsh-users/zsh-completions # aggregates zsh completion scripts
zinit_safe light Aloxaf/fzf-tab # use fzf for tab completions

# ==================== TURBO MODE LOADS ====================
# Visual enhancements - can load after prompt appears

# Priority 0a - Load first in async batch
zinit ice wait'0a' lucid atinit'ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20'
zinit_safe light zsh-users/zsh-autosuggestions # history based completions

# Priority 0b - Load second
zinit ice wait'0b' lucid
zinit_safe light zsh-users/zsh-syntax-highlighting # syntax highlights in commandline

# Priority 1 - Lower priority, load after 1 second
zinit ice wait'1' lucid
zinit_safe light MichaelAquilina/zsh-you-should-use # reminds you of aliases if you do not use them

# ==================== OH-MY-ZSH SNIPPETS ====================
# These are small, but can still defer

zinit ice wait'0c' lucid
zinit_safe snippet OMZL::git.zsh # oh-my-zsh git library

zinit ice wait'0c' lucid
zinit_safe snippet OMZP::sudo # esc-esc for sudo

zinit ice wait'0c' lucid
zinit_safe snippet OMZP::ssh # add .ssh/config completions
