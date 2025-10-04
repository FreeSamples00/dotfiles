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

zinit_safe light zsh-users/zsh-syntax-highlighting # syntax highlights in commandline
zinit_safe light zsh-users/zsh-autosuggestions # history based completions
zinit_safe light Aloxaf/fzf-tab # use fzf for tab completions
zinit_safe light MichaelAquilina/zsh-you-should-use # reminds you of aliases if you do not use them
zinit_safe light zsh-users/zsh-completions # aggregates zsh completion scripts
zinit_safe light laggardkernel/git-ignore # generate gitignores
zinit_safe snippet OMZL::git.zsh # no idea what this is for (might be important?)
zinit_safe snippet OMZP::git # git aliases
zinit_safe snippet OMZP::sudo # esc-esc for sudo
zinit_safe snippet OMZP::ssh # add .ssh/config completions
