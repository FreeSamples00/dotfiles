# ==============================================================================
#                                 _
#                         _______| |__  _ __ ___
#                        |_  / __| '_ \| '__/ __|
#                       _ / /\__ \ | | | | | (__
#                      (_)___|___/_| |_|_|  \___|
#
#                         ZSH Configuration File
# ==============================================================================

# ==================== CORE SETTINGS & VARIABLES ====================

DO_SPLASH_SCREEN=1

USE_ENHANCED_CLEAR=1

export EDITOR="nvim"
export VISUAL="nvim"
PAGER="bat --paging=always"

LINUX_FILE_MANAGER="xdg-open"

ERROR_STATUS=""

EMULATOR="ghostty"

alias echo='echo -e'

zle_bracketed_paste=1

setopt IGNORE_EOF

# ==================== INTERACTIVITY CHECK ====================

# Prevents execution if not in an interactive shell.
if [[ $- != *i* ]]; then
  return
fi

# ==================== OPERATING SYSTEM DETECTION ====================

case "$OSTYPE" in
  linux*)
    OPERATING_SYSTEM="linux"
    ;;
  darwin*)
    OPERATING_SYSTEM="macos"
    ;;
  *)
    OPERATING_SYSTEM=""
    ERROR_STATUS="$ERROR_STATUS\n\tNot a supported OS. ($OSTYPE)"
    ;;
esac

# ==================== ENVIRONMENT SETUP ====================

# ========== Homebrew Setup ==========

if [[ "$OPERATING_SYSTEM" == "macos" ]]; then

  if [[ -f "/opt/homebrew/bin/brew" ]] then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    ERROR_STATUS="$ERROR_STATUS\n\tHomeBrew path ''/opt/homebrew/bin/brew' not found (line ${LINENO})"
  fi

elif [[ "$OPERATING_SYSTEM" == "linux" ]]; then

  if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]] then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  else
    ERROR_STATUS="$ERROR_STATUS\n\tLinuxBrew path '/home/linuxbrew/.linxbrew/bin/brew' not found(line ${LINENO})"
  fi

fi

# ==================== TIMEKEEPING ====================

# take start time
START_TIME=$(gdate +%s%3N)

# ==================== ZINIT PLUGIN MANAGER ====================

# Set zinit directory.
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if not present.
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source Zinit.
source "${ZINIT_HOME}/zinit.zsh"

# ==================== ZSH PLUGINS & SNIPPETS ====================

# zinit wrapper w/ error 'handling'
function zinit_safe() {
  zinit "$@"
  if (( status != 0 )); then
    ERROR_STATUS="$ERROR_STATUS\n\tZinit $1 failed for '$2' (line: ${LINENO})"
  fi
}

# ========== ZSH Enhancements ==========

zinit_safe light zsh-users/zsh-syntax-highlighting # syntax highlights in commandline
zinit_safe light zsh-users/zsh-autosuggestions # history based completions
zinit_safe light Aloxaf/fzf-tab # use fzf for tab completions
zinit_safe light MichaelAquilina/zsh-you-should-use # reminds you of aliases if you do not use them
zinit_safe light zsh-users/zsh-completions # aggregates zsh completion scripts

# ========== Git & Utility Plugins ==========

fpath=(~/bin/wd $fpath)
zinit_safe light mfaerevaag/wd # warp directory TODO: remove?
zinit_safe light laggardkernel/git-ignore # generate gitignores

# ========== Oh-My-Zsh Snippets ==========

zinit_safe snippet OMZL::git.zsh # no idea what this is for (might be important?)
zinit_safe snippet OMZP::git # git aliases
zinit_safe snippet OMZP::sudo # esc-esc for sudo
zinit_safe snippet OMZP::ssh # add .ssh/config completions

# ==================== ZOXIDE ====================

unalias zi # zi is zinit by default
eval "$(zoxide init zsh)"
alias cd='z'
alias zd='zi'

# ==================== ZSH COMPLETION SETUP ====================

autoload -Uz compinit && compinit
zinit cdreplay -q

# Completion styling.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --line-range :500 ${(Q)realpath}'

# ==================== ZSH HISTORY CONFIGURATION ====================

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups

# ==================== PROGRAM-SPECIFIC CONFIGURATIONS ====================


# ========== MAN COLORIZING ==========

export LESS_TERMCAP_mb=$'\e[1;36m' # start blinking (bold cyan)
export LESS_TERMCAP_md=$'\e[1;33m' # start bold (bold yellow)
export LESS_TERMCAP_me=$'\e[0m'    # end attributes
export LESS_TERMCAP_so=$'\e[1;44;33m' # start standout (bold yellow on blue) - for headings/sections
export LESS_TERMCAP_se=$'\e[0m'    # end standout
export LESS_TERMCAP_us=$'\e[1;32m' # start underline (bold green) - for paths/filenames
export LESS_TERMCAP_ue=$'\e[0m'    # end underline
export LESS_TERMCAP_mh=$'\e[0m'    # disable half-bright
export LESS_TERMCAP_mr=$'\e[7m'    # enter reverse mode
export LESS_TERMCAP_ZJ=$'\e[1;35m' # bold magenta for comments (this one is less common, customize as needed)
export LESS_TERMCAP_ZN=$'\e[0m'    # end ZJ

# ========== FZF Configuration ==========

eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FXF_CTRL_T_COMMAND='$FZF_DEFAULT_COMMAND'
export FXF_ALT_C_COMMAND='fd --type=d --hidden --strip-cwd-prefix --exclude .git'
export FZF_DEFAULT_OPTS='--height 50% --layout=default --border --color=hl:#2dd4bf'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# ==================== FUNCTIONS ====================

# neovim shorthand
alias e="edit"
function edit() {
  local -a args

  if (( $# == 0 )); then
    args=(".")
  else
    args=("$@")
  fi

  "$EDITOR" "${args[@]}"
}

compdef _files edit

# Sends a macOS alert via terminal-notifier.
if [[ "$OPERATING_SYSTEM" == "macos" ]] && [[ "$EMULATOR" == "ghostty" ]]; then

  function alert() {
    TITLE='🚨Ghostty🚨'
    TERM_APP_ID="com.mitchellh.ghostty"
    SOUND_PATH="/system/library/sounds/Ping.aiff"

    if [[ "$@" == "" || "$@" == " " ]]; then
      echo "Alert" | terminal-notifier -title $TITLE -activate $TERM_APP_ID -ignoreDnD
    else
      echo $@ | terminal-notifier -title $TITLE -activate $TERM_APP_ID -ignoreDnD
    fi

    afplay $SOUND_PATH
  }

fi

# Overwrites `cat` with `bat` for interactive use.
function cat() {
  if [[ "$1" == "-h" || "$1" == "--help" ]] then
    bat -h
    exit 0
  fi

  if [[ -t 1 ]]; then
    command bat "$@"
  else
    command cat "$@"
  fi
}

compdef _files cat

# Gets the root of the current Git repository.
function git_root() {
  local root_dir=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ "$root_dir" == "" ]]; then
    echo "$(pwd)"
  else
    echo "$root_dir"
  fi
}

# Edits the project's .gitignore file.
function ignore() {
  $EDITOR "$(git_root)/.gitignore"
}

# Edits the project's TODO.md file.
function todo() {
  $EDITOR "$(git_root)/TODO.md"
}

# edit a project's README.md file
function readme() {
  $EDITOR "$(git_root)/README.md"
}

# ==================== TMUX CONFIGURATION & ALIASES ====================

function tmuxn() {
  if [[ "$1" != "" ]]; then
    command tmux new-session -s $1 "exec zsh"
  else
    command tmux new-session "exec zsh"
  fi
}

function tmuxa() {
  if [[ "$1" == "" ]]; then
    command tmux attach
  else
    command tmux attach -t "$1"
  fi
}

alias tmuxk="tmux kill-session"
alias tmuxl="tmux ls"
alias tmuxd="tmux detach"

# ==================== ALIASES ====================

# ========== General Aliases ==========

function enhanced_clear() {

  if [[ "$TMUX" != "" ]]; then
    clear
    return
  fi

  PROMPT_SIZE=5

  for _ in {$PROMPT_SIZE..$LINES}; do
    echo ""
  done

  printf $'\e[H\e[J'
}

if (( $USE_ENHANCED_CLEAR )); then
  alias c="enhanced_clear"
  alias cls="echo '\n' && enhanced_clear && echo && ls"
else
  alias c="clear"
  alias cls="clear && ls"
fi

# ========== Terminal Configuration Aliases ==========

alias config="edit ~/.zshrc"
alias vimconfig="edit ~/.config/nvim/"
alias reload='clear && exec zsh'

# ========== Media Playback ==========

function play() {
  if ! [[ -f "$1" ]]; then
    printf "\033[91mERR: file not found\033[0m\n"
    exit 1
  fi

  command nohup mpv "$1" &>/dev/null &
}
compdef _files play

# ========== File Operation Aliases ==========

alias tree='tree -haC -I .git'
alias cwd='pwd | copy'
alias ls='eza --color=automatic --icons=automatic --no-user -a --group-directories-first --sort=type'

if [[ "$OPERATING_SYSTEM" == "macos" ]]; then
  alias ofd='open -R "$(pwd)"'

elif [[ "$OPERATING_SYSTEM" == "linux" ]]; then
  alias ofd="$LINUX_FILE_MANAGER ."

fi

# ========== Grep / Search Aliases ==========

alias grep='grep -ni --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv}'
alias grepa='rga -niu'
alias grepf='fd -u | rg -iu'
alias grepd='fd -u -t d | rg -iu'

# ========== Clipboard Aliases ==========

if [[ "$OPERATING_SYSTEM" == "macos" ]]; then

  alias copy='pbcopy'
  alias paste='pbpaste'

elif [[ "$OPERATING_SYSTEM" == "linux" ]]; then

  alias copy='xclip -selection clipboard -i'
  alias paste='xclip -selection clipboard -o'

fi

# ========== System Information Aliases ==========

alias info="fastfetch"
alias '?'='echo $?'

# ========== Git Operation Aliases ==========

alias gi='git-ignore'
alias lg='lazygit'

# ========== Command Replacements ==========

alias top='btop'
alias diff='delta --side-by-side'
alias listen='/bin/cat -v'
alias path='print -c ${(s/:/)PATH} | bat --file-name "\$PATH"'
alias clear="\clear" # fixes spacing for ghostty

# ========== Enhanced Core Commands ==========

alias less='less -R'
alias rm='rm -I'
alias gcc='gcc -Wall'

# ========== Utility Tools ==========

alias wclone='wget --mirror --convert-links --adjust-extension --page-requisites --show-progress'
alias update='brew update && brew upgrade && zinit update'
alias stow='stow -v'
alias sizeof='du -hs'
alias storage="dust -rC | bat --file-name 'Storage Breakdown'"
alias colors='terminal_colors.sh'
alias 2pdf='mdpdf --ghstyle=true --border 0.5in'
alias ghidra="ghidraRun"
alias bench='hyperfine'

# ========== macOS Specific Utilities ==========

if [[ "$OPERATING_SYSTEM" == "macos" ]]; then
  alias battery='system_profiler SPPowerDataType | grep -E "Cycle Count|Condition|Maximum Capacity" | bat'
fi

# ========== Help Output Formatting Aliases (Global) ==========

alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'


# ==================== ERROR CHECK ====================

if [[ "$ERROR_STATUS" != "" ]]; then
  DO_SPLASH_SCREEN=0
  local MESSAGE_LENGTH=35
  echo -ne "\n\n\033[91mErrors During Zsh Initialization\033[90m "
  for _ in {$MESSAGE_LENGTH..$COLUMNS}; do
    echo -n "="
  done
  echo -e "\033[0m"
  echo -e "$ERROR_STATUS"
  echo -e " \033[90m"
  for _ in {2..$COLUMNS}; do
    echo -n "="
  done
  echo "\033[0m\n\n"
fi

# ==================== LOGIN ACTIONS ====================

# ========== SPLASH SCREEN ==========

if [[ "$OPERATING_SYSTEM" == "macos" ]]; then
  NAME=$(scutil --get ComputerName)
elif [[ "$OPERATING_SYSTEM" == "linux" ]]; then
  NAME=$(hostname | \grep -E -o '^[^.]+')
else
  NAME ="NAME NOT FOUND"
fi

if (( DO_SPLASH_SCREEN )); then
  echo $NAME | figlet -c -w $COLUMNS | lolcat -f
fi

# ========== DISPLAY LOAD TIME ==========

# get end time
END_TIME=$(gdate +%s%3N)

# Calculate and display load time.
echo "\033[90mzsh load time: $(( END_TIME - START_TIME ))ms\033[0m"

# ========== PROMPT ==========

eval "$(starship init zsh)"

# ========== SET CURSOR AND INPUT MODE ==========

printf '\e[5 q' # blinking bar
bindkey -e
