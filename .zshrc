# ==============================================================================
#                                 _
#                         _______| |__  _ __ ___ 
#                        |_  / __| '_ \| '__/ __|
#                       _ / /\__ \ | | | | | (__ 
#                      (_)___|___/_| |_|_|  \___|
#
#                         ZSH Configuration File
# ==============================================================================

# ============================ 1. INTERACTIVITY CHECK ==========================
# Prevents execution if not in an interactive shell.
# ==============================================================================
if [[ $- != *i* ]]; then
    return
fi

# ============================ 2. CORE SETTINGS & VARIABLES ====================
# Configuration variables for shell behavior, editors, and display.
# ==============================================================================

# 2.1. Login & Splash Screen Configuration
# ------------------------------------------------------------------------------
# choose a login action
#   'none': do nothing
#   'hostname-pretty': use figlet and lolcat to pretty print the machine name
#   'hostname-basic': use echo and ASCII color codes to print the machine name
#   'quote-tame': use fortune and cowsay to display a safe for work quote
#   'quote-nsfw': use fortune and cowsay to display a quote (can be not safe for work)
#       Note: This will not work with some fortune packages that do not come bundled with offensive options
SPLASH_SCREEN="hostname-pretty"
LOGIN_MESSAGES=1

# choice of cowsay file (the thing that says the message) I like
COWSAY_CHOICE="tux"

# 2.2. Editor Definitions
# ------------------------------------------------------------------------------
# default editor for aliases defined here
TERMINAL_EDITOR="nvim"
GUI_EDITOR="neovide"
IDE_EDITOR="code"

EDITOR=$TERMINAL_EDITOR

# 2.3. File Manager Configuration
# ------------------------------------------------------------------------------
# whatever GUI file manager your machine uses
LINUX_FILE_MANAGER="xdg-open"

# 2.4. Internal Script Variables & Error Handling
# ------------------------------------------------------------------------------
# keep at 0, is changed later on if issues occur
ZSHRC_ERR=0

# 2.5. Terminal Behavior & Capabilities
# ------------------------------------------------------------------------------
# enable escape code support during zshrc initialization
alias echo='echo -e'

# enable bracketed pasting (avoids accidental execution w/ a newline character)
zle_bracketed_paste=1

# terminal emulator being used
EMULATOR="ghostty"

# does the terminal emulator support images
GRAPHICS_SUPPORT=1

# enable and disable vim motions in the commandline
VIM_MODE=0

# this line prevents a single EOF char (Ctrl+d) from killing the shell
setopt IGNORE_EOF

# -------------------------------------------------------------------------------
function err() {
  if (( $# != 1 )); then
    echo "Bad args calling err"
    exit 1
  fi
  echo -e "\033[91mERR: $1\033[0m"
}

# ============================ 3. OPERATING SYSTEM DETECTION ===================
# Determines the current operating system for platform-specific configurations.
# ==============================================================================
IS_LINUX=0
IS_MACOS=0

case "$OSTYPE" in
  linux*)
    IS_LINUX=1
    ;;
  darwin*)
    IS_MACOS=1
    ;;
  *)
    err "Not a supported OS. ($OSTYPE)"
    exit 1
    ;;
esac

# ============================ 4. INITIAL LOGIN ACTIONS ========================
# Executes commands based on the configured splash screen setting.
# ==============================================================================
sleep 0.05 # just enough time for aerospace to kick in before the splash screen
if (( IS_MACOS )); then
  NAME=$(scutil --get ComputerName)
elif (( IS_LINUX )); then
  NAME=$(hostname | \grep -E -o '^[^.]+')
else
  NAME ="NAME NOT FOUND"
fi

case "$SPLASH_SCREEN" in
  "hostname-pretty")
    clear
    echo $NAME | figlet -c -w $COLUMNS | lolcat -f
    ;;
  "hostname-basic")
    clear
    echo $NAME | xargs echo -e "\033[93mMachine: "
    echo "\033[0m"
    ;;
  "quote-tame")
    clear
    quote_size=$(( (COLUMNS * 3) / 4))
    fortune -s | cowthink -f ${COWSAY_CHOICE} -W ${quote_size}
    ;;
  "quote-nsfw")
    clear
    quote_size=$(( (COLUMNS * 3) / 4))
    fortune -as | cowthink -f ${COWSAY_CHOICE} -W ${quote_size}
    ;;
  "none")
    LOGIN_MESSAGES=0
    ;;
  *)
    echo "\033[91mLogin action not supported ($SPLASH_SCREEN)\033[0m"
    ;;
esac

if (( $LOGIN_MESSAGES )); then

  if (( $VIM_MODE )); then
    echo "\033[90mInput Mode: Vim\033[0m"
  else
    echo "\033[90mInput Mode: Emacs\033[0m"
  fi

fi

# make cursor blinking bar
printf '\e[5 q'

# ============================ 5. POWERLEVEL10K INSTANT PROMPT =================
# Essential for fast prompt rendering. Must be near the top.
# ==============================================================================
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
else
  echo "PowerLevel10k path '${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh' not found"
  ZSHRC_ERR=1
fi

# ============================ 6. ENVIRONMENT SETUP ============================
# Configures system-wide environment variables and paths.
# ==============================================================================

# 6.1. Homebrew Setup
# ------------------------------------------------------------------------------
if (( IS_MACOS )); then

  if [[ -f "/opt/homebrew/bin/brew" ]] then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo "HomeBrew path ''/opt/homebrew/bin/brew' not found"
    ZSHRC_ERR=2  
  fi
  
elif (( IS_LINUX )); then

  if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]] then
  	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  else
    echo "LinuxBrew path '/home/linuxbrew/.linxbrew/bin/brew' not found"
    ZSHRC_ERR=2
  fi
  
fi

# 6.2. Path Additions
# ------------------------------------------------------------------------------
export PATH="/usr/local/bin:$PATH"
export PATH="$PATH:/Users/sccmp/.local/bin"
export PATH="/usr/local/texlive/2025/bin/universal-darwin:$PATH"

# ============================ 7. ZINIT PLUGIN MANAGER SETUP ===================
# Initializes Zinit and prepares for plugin loading.
# ==============================================================================
# Set zinit directory
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if needed
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source zinit
source "${ZINIT_HOME}/zinit.zsh"

# ============================ 8. ZSH PLUGINS & SNIPPETS =======================
# Loads various Zsh plugins and Oh-My-Zsh snippets via Zinit.
# ==============================================================================
function zinit_safe() {
  zinit "$@"
  if (( status != 0 )); then
    echo "\033[91mZinit $1 failed for '$2'\033[0m"
    ZSHRC_ERR=3
  fi
}

# Theme
zinit_safe ice depth=1; zinit_safe light romkatv/powerlevel10k

# ZSH enhancements
zinit_safe light zsh-users/zsh-syntax-highlighting
zinit_safe light zsh-users/zsh-autosuggestions
zinit_safe light Aloxaf/fzf-tab
zinit_safe light MichaelAquilina/zsh-you-should-use
zinit light zsh-users/zsh-completions

# Git and utility plugins
fpath=(~/bin/wd $fpath)
zinit_safe light mfaerevaag/wd
zinit_safe light laggardkernel/git-ignore

# Oh-My-Zsh snippets
zinit_safe snippet OMZL::git.zsh
zinit_safe snippet OMZP::git
zinit_safe snippet OMZP::sudo
zinit_safe snippet OMZP::command-not-found

zinit_safe snippet OMZP::colorize
zinit_safe snippet OMZP::git
zinit_safe snippet OMZP::colored-man-pages
zinit_safe snippet OMZP::git
zinit_safe snippet OMZP::safe-paste
zinit_safe snippet OMZP::git-auto-fetch
zinit_safe snippet OMZP::zbell
zinit_safe snippet OMZP::ssh

# ============================ 9. ZSH COMPLETION SETUP =========================
# Configures Zsh's auto-completion system and FZF-tab.
# ==============================================================================
autoload -Uz compinit && compinit
zinit cdreplay -q

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --line-range :500 ${(Q)realpath}'

# ============================ 10. POWERLEVEL10K CONFIGURATION ==================
# Customizes the appearance and behavior of the Powerlevel10k prompt.
# ==============================================================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Prompt customization
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=""

# ============================ 11. ZSH HISTORY CONFIGURATION ====================
# Defines how command history is managed.
# ===============================================================================
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

# ============================ 12. PROGRAM-SPECIFIC CONFIGURATIONS =============
# Settings for various command-line tools.
# ===============================================================================

# 12.1. Less / Man Configuration
# -------------------------------------------------------------------------------
export LESS="--mouse --wheel-lines=3"
export MAN="--mouse --wheel-lines=3"

# 12.2. FZF Configuration
# -------------------------------------------------------------------------------
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FXF_CTRL_T_COMMAND='$FZF_DEFAULT_COMMAND'
export FXF_ALT_C_COMMAND='fd --type=d --hidden --strip-cwd-prefix --exclude .git'
export FZF_DEFAULT_OPTS='--height 50% --layout=default --border --color=hl:#2dd4bf'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# ============================ 13. EDITOR ENVIRONMENT CONFIG ===================
# Dynamically sets the default editor based on SSH connection status.
# ===============================================================================
# set default editor for apps to use based on remote / local
if [[ -n "$SSH_CONNECTION" || -n "$SSH_CLIENT" ]]; then
    export EDITOR="$TERMINAL_EDITOR"
    export VISUAL="$TERMINAL_EDITOR"
else
    export EDITOR="$GUI_EDITOR"
    export VISUAL="$GUI_EDITOR"
fi

# ============================ 14. FUNCTIONS ===================================
# Custom shell functions for extended functionality.
# ===============================================================================

# 14.1. Editor Call Functions
# -------------------------------------------------------------------------------
alias e="edit"
function edit() {
  local -a args
  if (( $# == 0 )); then
    args=(".")
  else
    args=("$@")
  fi

  "$TERMINAL_EDITOR" "${args[@]}"
}
compdef _files edit

alias eg="editg"
function editg() {
	local -a args

  if (( $# == 0 )); then
    args=(".")
  else 
    args=("$@")
  fi
  
  if (( IS_MACOS )); then
    "$GUI_EDITOR" --frame buttonless "${args[@]}" >/dev/null 2>&1 & disown
  else
    "$GUI_EDITOR" --frame transparent "${args[@]}" >/dev/null 2>&1 & disown
  fi
}
compdef _files editg

# 14.2. General Utility Functions
# -------------------------------------------------------------------------------
### sends a macos alert
if (( IS_MACOS )) && [[ "$EMULATOR" == "ghostty" ]]; then
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

### overwrites cat, using bat interactivley and default cat in pipes
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

### gets the root of git repo, if no repo present returns cwd
function git_root() {
  local root_dir=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ "$root_dir" == "" ]]; then
    echo "$(pwd)"
  else
    echo "$root_dir"
  fi
}

### edit the project gitignore
function ignore() {
  $TERMINAL_EDITOR "$(git_root)/.gitignore"
}

### edit project todo file
function todo() {
  $TERMINAL_EDITOR "$(git_root)/TODO.md"
}

# ============================ 15. TMUX CONFIGURATION & ALIASES ================
# Settings and aliases for Tmux.
# ===============================================================================

### create new tmux session
function tmuxn() {
  if [[ "$1" != "" ]]; then
    command tmux new-session -s $1 "exec zsh"
  else
    command tmux new-session "exec zsh"
  fi
}

## tmux
alias tmuxk="tmux kill-session"
alias tmuxl="tmux ls"
alias tmuxa="tmux attach"
alias tmuxd="tmux detatch"

# ============================ 16. ALIASES =====================================
# Shortcuts for frequently used commands.
# ===============================================================================

# 16.1. Editor Aliases
# -------------------------------------------------------------------------------
alias ide="$IDE_EDITOR"

# 16.2. General Aliases
# -------------------------------------------------------------------------------
alias c="clear"
alias cls="clear && ls"

# 16.3. Terminal Configuration Aliases
# -------------------------------------------------------------------------------
alias config="edit ~/.zshrc"
alias vimconfig="edit ~/.config/nvim/"
alias reload='clear && exec zsh'

# 16.4. Media Playback Aliases
# -------------------------------------------------------------------------------
function play() {
  if ! [[ -f "$1" ]]; then
    err "File not found"
    exit 1
  fi

  command nohup mpv "$1" &>/dev/null &
}
compdef _files play

# 16.6. File Operation Aliases
# -------------------------------------------------------------------------------
alias tree='tree -haC'
alias cwd='pwd | copy'
alias ls='eza --color=automatic --icons=automatic --no-user -a --group-directories-first --sort=type'

if (( IS_MACOS )); then
  alias ofd='open -R "$(pwd)"'
elif (( IS_LINUX )); then
  alias ofd="$LINUX_FILE_MANAGER ."
fi

# 16.7. Grep / Search Aliases
# -------------------------------------------------------------------------------
alias grep='grep -ni --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv}'
alias grepa='rga -niu'
alias grepf='fd -u | rg -iu'
alias grepd='fd -u -t d | rg -iu'

# 16.8. Clipboard Aliases
# -------------------------------------------------------------------------------
if (( IS_MACOS )); then

  alias copy='pbcopy'
  alias paste='pbpaste'

elif (( IS_LINUX )); then

  alias copy='xclip -selection clipboard -i'
  alias paste='xclip -selection clipboard -o'

fi

# 16.9. System Information Aliases
# -------------------------------------------------------------------------------
alias info="fastfetch"
alias '?'='echo $?'

# 16.10. Git Operation Aliases
# -------------------------------------------------------------------------------
alias gi='git-ignore'
alias lg='lazygit'

# 16.11. Command Replacements
# -------------------------------------------------------------------------------
alias top='btop'
alias diff='delta --side-by-side'
alias listen='/bin/cat -v'
alias path='print -c ${(s/:/)PATH} | bat --file-name "\$PATH"'
alias clear="\clear" # this fixes spacing when using ghostty w/out titlebar

# 16.12. Enhanced Core Commands
# -------------------------------------------------------------------------------
alias less='less -r'
alias rm='rm -I'
alias gcc='gcc -Wall'

# 16.13. Utility Tools
# -------------------------------------------------------------------------------
alias wclone='wget --mirror --convert-links --adjust-extension --page-requisites --show-progress'
alias update='brew update && brew upgrade && zinit update'
alias py='uv'
alias stow='stow -v'
alias sizeof='du -hs'
alias storage="dust -rC | bat --file-name 'Storage Breakdown'"
alias wordcount="wc -w"
alias colors='terminal_colors.sh' 
alias 2pdf='mdpdf --ghstyle=true --border 0.5in'
alias ghidra="ghidraRun"

# 16.13. AI tools
# -------------------------------------------------------------------------------

### Prompt a local model
function prompt() {
  MODEL="gpt-oss:20b"
  PROMPT=""
  RAW_OUTPUT=0
  THINKING_MODE=""

  while getopts "lrhm:t:" opt; do
    case "$opt" in
      l)
        ollama list | tail -n +2 | awk '{print $1}' | cat --file-name "MODELS"
        return 0
        ;;
      h)
        echo -e "Prompt an llm locally\n"
        echo -e "Usage: prompt [flags] message\n"
        echo -e "Options:"
        echo -e "\t-h\t\tThis help message"
        echo -e "\t-m\t\tChoose a model (default: $MODEL)"
        echo -e "\t-r\t\tShow raw output (normally uses glow for formatting)"
        echo -e "\t-l\t\tList available models"
        echo -e "\t-t\t\tThinking mode. Options: true/false, low/medium/high"
        return 0
        ;;
      m)
        if ! ollama list | grep -q "$OPTARG"; then
          err "Model not found, check w/ 'ollama list'"
          return 1
        fi
        MODEL="$OPTARG"
        ;;
      t)
        OPTIONS="true, false, high, medium, low"
        if ! echo "$OPTIONS" | sed -E 's/, */\n/g' | grep -qxF "$OPTARG"; then
          err "Thinking option '$OPTARG' invalid. Options: $OPTIONS"
          return 1
        fi
        THINKING_MODE="$OPTARG"
        ;;
      r)
        RAW_OUTPUT=1
        ;;
      *)
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))
  PROMPT="$1"

  if [[ "$THINKING_MODE" == "" ]]; then
    OUTPUT=$(command ollama run "$MODEL" --hidethinking "$PROMPT")
  else
    OUTPUT=$(command ollama run "$MODEL" --think="$THINKING_MODE" --hidethinking "$PROMPT")
  fi

  if (( RAW_OUTPUT )); then
    echo "$OUTPUT"
  else
    echo "$OUTPUT" | glow
  fi
}

# 16.14. macOS Specific Utilities
# -------------------------------------------------------------------------------
if (( IS_MACOS )); then
    alias battery='system_profiler SPPowerDataType | grep -E "Cycle Count|Condition|Maximum Capacity" | bat' 
    alias manp='man-preview'
fi

# 16.15. Graphical Utilities
# -------------------------------------------------------------------------------
if (( $GRAPHICS_SUPPORT == 1 )); then
    alias xkcd='curl -H "X-TERMINAL-ROWS: $(tput lines)" -H "X-TERMINAL-COLUMNS: $(tput cols)" https://xkcd.massi.rocks/comics/random'
fi

# 16.16. Help Output Formatting Aliases (Global)
# -------------------------------------------------------------------------------
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# ============================ 17. COMMAND LINE EDITOR & KEYBINDS ==============
# Configures Zsh's line editor mode (Vi/Emacs) and custom keybindings.
# ===============================================================================
if (( $VIM_MODE )); then

  USE_PLUGIN=0
  
  if (( $USE_PLUGIN )); then # zsh-vi-mode plugin
    zinit ice depth=1
    zinit light jeffreytse/zsh-vi-mode

  else # built-in zsh vi mode
    bindkey -v # sets vim mode

    # function that changes the caret shape based on vim mode
    change_caret() {
      if [[ $KEYMAP == vicmd ]]; then
        printf '\e[2 q'
      elif [[ $KEYMAP == vireplace ]]; then
        printf '\e[4 q'
      elif [[ $KEYMAP == main || $KEYMAP == viins ]]; then
        printf '\e[6 q'
      fi
    }

    zle -N zle-line-init change_caret
    zle -N zle-keymap-select change_caret

  fi

else # emacs mode

  bindkey -e 

fi

# ============================ 18. FINAL ERROR CHECK ===========================
# Displays an error message if initialization issues occurred.
# ===============================================================================
if (( ZSHRC_ERR )); then
  SPLASH_SCREEN="none"
  echo "\033[91mzsh initialization encountered an error. code: $ZSHRC_ERR\033[0m"
fi
