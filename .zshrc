# ==============================================================================
#                                 _
#                         _______| |__  _ __ ___ 
#                        |_  / __| '_ \| '__/ __|
#                       _ / /\__ \ | | | | | (__ 
#                      (_)___|___/_| |_|_|  \___|
#
#                         ZSH Configuration File
# ==============================================================================

# ==================== PRE-INITIALIZATION ====================

# Initial pause for window tiling
sleep 0.1

# Timekeeping start
START_TIME=$(gdate +%s%3N)

# ==================== INTERACTIVITY CHECK ====================
# Prevents execution if not in an interactive shell.
if [[ $- != *i* ]]; then
    return
fi

# ==================== CORE SETTINGS & VARIABLES ====================

# ========== Login & Splash Screen Configuration ==========
# Define splash screen and login message behavior.
SPLASH_SCREEN="hostname-pretty"
LOGIN_MESSAGES=1
COWSAY_CHOICE="tux"

# ========== Editor Definitions ==========
# Set default terminal, GUI, and IDE editors.
TERMINAL_EDITOR="nvim"
GUI_EDITOR="neovide"
IDE_EDITOR="code"
EDITOR=$TERMINAL_EDITOR

# ========== File Manager Configuration ==========
# Specify GUI file manager for Linux.
LINUX_FILE_MANAGER="xdg-open"

# ========== Internal Script Variables ==========
# Error flag for Zshrc initialization.
ZSHRC_ERR=0

# ========== Terminal Behavior & Capabilities ==========
# Enable escape codes, bracketed paste, and EOF protection.
alias echo='echo -e'
zle_bracketed_paste=1
EMULATOR="ghostty"
GRAPHICS_SUPPORT=1
VIM_MODE=0
setopt IGNORE_EOF

# ==================== ERROR HANDLING ====================
# Function to display error messages.
function err() {
  if (( $# != 1 )); then
    echo "Bad args calling err"
    exit 1
  fi
  echo -e "\033[91mERR: $1\033[0m"
}

# ==================== OPERATING SYSTEM DETECTION ====================
# Determine current OS for platform-specific configurations.
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


# ========== Path Additions ==========
# Append common binary paths to the PATH variable.
export PATH="/usr/local/bin:$PATH"
export PATH="$PATH:/Users/sccmp/.local/bin"
export PATH="/usr/local/texlive/2025/bin/universal-darwin:$PATH"

# ==================== INITIAL LOGIN ACTIONS ====================
# Execute splash screen based on configuration.
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

# Set cursor blinking bar.
printf '\e[5 q'

# ==================== ENVIRONMENT SETUP ====================

# ========== Homebrew Setup ==========
# Initialize Homebrew for macOS or Linuxbrew for Linux.
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

# ==================== ZINIT PLUGIN MANAGER ====================
# Initialize Zinit and prepare for plugin loading.

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
# Load Zsh plugins and Oh-My-Zsh snippets via Zinit.

# Safe Zinit wrapper.
function zinit_safe() {
  zinit "$@"
  if (( status != 0 )); then
    echo "\033[91mZinit $1 failed for '$2'\033[0m"
    ZSHRC_ERR=3
  fi
}

# ========== ZSH Enhancements ==========
zinit_safe light zsh-users/zsh-syntax-highlighting
zinit_safe light zsh-users/zsh-autosuggestions
zinit_safe light Aloxaf/fzf-tab
zinit_safe light MichaelAquilina/zsh-you-should-use
zinit light zsh-users/zsh-completions

# ========== Git & Utility Plugins ==========
fpath=(~/bin/wd $fpath)
zinit_safe light mfaerevaag/wd
zinit_safe light laggardkernel/git-ignore

# ========== Oh-My-Zsh Snippets ==========
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

# ==================== ZSH COMPLETION SETUP ====================
# Configure Zsh's auto-completion and FZF-tab.
autoload -Uz compinit && compinit
zinit cdreplay -q

# Completion styling.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --line-range :500 ${(Q)realpath}'

# ==================== ZSH HISTORY CONFIGURATION ====================
# Define command history management.
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

# ========== Less / Man Configuration ==========
# Configure Less and Man for scrolling.
export LESS="--mouse --wheel-lines=3"
export MAN="--mouse --wheel-lines=3"

# ========== FZF Configuration ==========
# Configure FZF environment variables and options.
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FXF_CTRL_T_COMMAND='$FZF_DEFAULT_COMMAND'
export FXF_ALT_C_COMMAND='fd --type=d --hidden --strip-cwd-prefix --exclude .git'
export FZF_DEFAULT_OPTS='--height 50% --layout=default --border --color=hl:#2dd4bf'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# ==================== EDITOR ENVIRONMENT CONFIG ====================
# Dynamically sets the default editor based on SSH connection.
if [[ -n "$SSH_CONNECTION" || -n "$SSH_CLIENT" ]]; then
    export EDITOR="$TERMINAL_EDITOR"
    export VISUAL="$TERMINAL_EDITOR"
else
    export EDITOR="$GUI_EDITOR"
    export VISUAL="$GUI_EDITOR"
fi

# ==================== FUNCTIONS ====================

# ========== Editor Call Functions ==========
# Aliases and functions for opening files with configured editors.
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

# ========== General Utility Functions ==========
# Custom functions for various utilities.
if (( IS_MACOS )) && [[ "$EMULATOR" == "ghostty" ]]; then
  # Sends a macOS alert via terminal-notifier.
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
  $TERMINAL_EDITOR "$(git_root)/.gitignore"
}

# Edits the project's TODO.md file.
function todo() {
  $TERMINAL_EDITOR "$(git_root)/TODO.md"
}

# ==================== TMUX CONFIGURATION & ALIASES ====================

# ========== Tmux Functions ==========
# Function to create a new tmux session.
function tmuxn() {
  if [[ "$1" != "" ]]; then
    command tmux new-session -s $1 "exec zsh"
  else
    command tmux new-session "exec zsh"
  fi
}

# ========== Tmux Aliases ==========
# Shortcuts for common tmux commands.
alias tmuxk="tmux kill-session"
alias tmuxl="tmux ls"
alias tmuxa="tmux attach"
alias tmuxd="tmux detach"

# ==================== ALIASES ====================
# Shortcuts for frequently used commands.

# ========== Editor Aliases ==========
alias ide="$IDE_EDITOR"

# ========== General Aliases ==========
alias c="clear"
alias cls="clear && ls"

# ========== Terminal Configuration Aliases ==========
alias config="edit ~/.zshrc"
alias vimconfig="edit ~/.config/nvim/"
alias reload='clear && exec zsh'

# ========== Media Playback Aliases ==========
# Function to play media files.
function play() {
  if ! [[ -f "$1" ]]; then
    err "File not found"
    exit 1
  fi

  command nohup mpv "$1" &>/dev/null &
}
compdef _files play

# ========== File Operation Aliases ==========
alias tree='tree -haC'
alias cwd='pwd | copy'
alias ls='eza --color=automatic --icons=automatic --no-user -a --group-directories-first --sort=type'

if (( IS_MACOS )); then
  alias ofd='open -R "$(pwd)"'
elif (( IS_LINUX )); then
  alias ofd="$LINUX_FILE_MANAGER ."
fi

# ========== Grep / Search Aliases ==========
alias grep='grep -ni --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv}'
alias grepa='rga -niu'
alias grepf='fd -u | rg -iu'
alias grepd='fd -u -t d | rg -iu'

# ========== Clipboard Aliases ==========
if (( IS_MACOS )); then
  alias copy='pbcopy'
  alias paste='pbpaste'
elif (( IS_LINUX )); then
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
alias less='less -r'
alias rm='rm -I'
alias gcc='gcc -Wall'

# ========== Utility Tools ==========
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

# ========== AI Tools ==========
# Function to prompt a local LLM.
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

# ========== macOS Specific Utilities ==========
if (( IS_MACOS )); then
    alias battery='system_profiler SPPowerDataType | grep -E "Cycle Count|Condition|Maximum Capacity" | bat'
    alias manp='man-preview'
fi

# ========== Graphical Utilities ==========
if (( $GRAPHICS_SUPPORT == 1 )); then
    alias xkcd='curl -H "X-TERMINAL-ROWS: $(tput lines)" -H "X-TERMINAL-COLUMNS: $(tput cols)" https://xkcd.massi.rocks/comics/random'
fi

# ========== Help Output Formatting Aliases (Global) ==========
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# ==================== COMMAND LINE EDITOR & KEYBINDS ====================
# Configures Zsh's line editor mode (Vi/Emacs) and custom keybindings.
if (( $VIM_MODE )); then

  USE_PLUGIN=0

  if (( $USE_PLUGIN )); then # zsh-vi-mode plugin
    zinit ice depth=1
    zinit light jeffreytse/zsh-vi-mode

  else # built-in zsh vi mode
    bindkey -v # sets vim mode

    # Function that changes the caret shape based on vim mode.
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

# ==================== FINAL ERROR CHECK ====================
# Displays an error message if initialization issues occurred.
if (( ZSHRC_ERR )); then
  SPLASH_SCREEN="none"
  echo "\033[91mzsh initialization encountered an error. code: $ZSHRC_ERR\033[0m"
fi

eval "$(starship init zsh)"

# Timekeeping end
END_TIME=$(gdate +%s%3N)

# Calculate and display load time.
echo "\033[90mLoad time: $(( END_TIME - START_TIME ))ms\033[0m"
