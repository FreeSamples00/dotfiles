# ================== Interactivity Check ==================
if [[ $- != *i* ]]; then
    return
fi

# ================== ZSHRC SETTINGS ==================

# choose a login action
#   'none': do nothing
#   'hostname-pretty': use figlet and lolcat to pretty print the machine name
#   'hostname-basic': use echo and ASCII color codes to print the machine name
#   'quote-tame': use fortune and cowsay to display a safe for work quote
#   'quote-nsfw': use fortune and cowsay to display a quote (can be not safe for work)
#       Note: This will not work with some fortune packages that do not come bundled with offensive options
LOGIN_ACTION="quote-nsfw"

# choice of cowsay file (the thing that says the message) I like
COWSAY_CHOICE="tux"

# default editor for aliases defined here
TERMINAL_EDITOR="nvim"
GUI_EDITOR="neovide"
IDE_EDITOR="code"

# whatever GUI file manager your machine uses
LINUX_FILE_MANAGER="xdg-open"

# keep at 0, is changed later on if issues occur
ZSHRC_ERR=0

# path to the help message file (used by 'help' and 'edit_help')
HELP_PATH="~/.dotfiles/misc_configs/help_msg.zsh"

# enable escape code support during zshrc initialization
alias echo='echo -e'

# =================== DETERMINE OS ===================

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
    echo "\033[91mNot a supported OS. ($OSTYPE)\033[0m"
    exit
    ;;
esac

# =================== POWERLEVEL10K SETUP ===================
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
else
  echo "PowerLevel10k path '${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh' not found"
  ZSHRC_ERR=1
fi

# =================== ENVIRONMENT SETUP ===================

## homebrew setup
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

# Path additions
export PATH="/usr/local/bin:$PATH"

# =================== ZINIT SETUP ===================
# Set zinit directory
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if needed
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source zinit
source "${ZINIT_HOME}/zinit.zsh"

# =================== PLUGINS ===================

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

# =================== COMPLETION SETUP ===================
autoload -Uz compinit && compinit
zinit cdreplay -q

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --line-range :500 ${(Q)realpath}'

# =================== POWERLEVEL10K CONFIGURATION ===================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Prompt customization
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=""

# =================== HISTORY CONFIGURATION ===================
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
setopt hist_find_no_dups

# =================== PROGRAM CONFIGURATIONS ===================
# Less/Man configuration
export LESS="--mouse --wheel-lines=3"
export MAN="--mouse --wheel-lines=3"

# FZF configuration
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FXF_CTRL_T_COMMAND='$FZF_DEFAULT_COMMAND'
export FXF_ALT_C_COMMAND='fd --type=d --hidden --strip-cwd-prefix --exclude .git'
export FZF_DEFAULT_OPTS='--height 50% --layout=default --border --color=hl:#2dd4bf'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"


# =================== ALIASES ===================


## Editor calls
alias edit="$TERMINAL_EDITOR" 

function editg() {
	local -a args
	if (( $# == 0 )); then
		# Use '.' for the current directory.
		args=(".")
	else
		args=("$@")
	fi

	# 4. Execution: Launch, silence output, background, and disown.
	"$GUI_EDITOR" --frame transparent "${args[@]}" >/dev/null 2>&1 & disown
}

alias ide="$IDE_EDTIOR"

## Terminal Configuration
alias config="editg ~/.zshrc"
alias vimconfig="editg ~/.config/nvim/init.lua"
alias edit_help="edit $HELP_PATH"
alias help="cat $HELP_PATH --file-name help_message.zsh"
alias reload='clear && exec zsh'


## Applications
alias search='s -p duckduckgo'
alias idle='idle3'

## Games
if (( IS_MACOS )); then
  alias doom='wd zig terminal-doom && ./run.sh'
  alias doom-fire='wd zig DOOM-fire-zig && ./run.sh'
  alias snake='nsnake'
fi

## File Operations
alias tree='tree -haC'
alias cwd='pwd | copy'
alias ls='eza --color=automatic --icons=automatic --no-user -a --group-directories-first --sort=type'

if (( IS_MACOS )); then
  alias ofd='open -R "$(pwd)"'
elif (( IS_LINUX )); then
  alias ofd="$LINUX_FILE_MANAGER ."
fi

## Search Operations
alias grep='grep -ni --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv}'
alias grepa='rga -ni'
alias grepf='fd -u | rg -i'
alias greph='rg --passthru'

## Disk Operations
alias dd="sudo gdd status=progress conv=sync"

## Clipboard Operations
if (( IS_MACOS )); then
  alias copy='pbcopy'
  alias paste='pbpaste'
elif (( IS_LINUX )); then
  alias copy='xclip -selection clipboard -i'
  alias paste='xclip -selection clipboard -o'
fi

## System Information
alias info="neofetch"
alias '?'='echo $?'

if (( IS_MACOS )); then
  alias manp='man-preview'
fi

## Git Operations
alias ignore="$DEFAULT_EDITOR ./.gitignore"
alias gi='git-ignore'
alias lg='lazygit'

## Command Replacements
alias top='btop'
alias diff='delta --side-by-side'
alias listen='/bin/cat -v'
alias path='print -c ${(s/:/)PATH} | bat --file-name "\$PATH"'

## Adaptive cat function
function cat() {
    if [[ -t 1 ]]; then
        command bat "$@"
    else
        command cat "$@"
    fi
}

## Enhanced Commands
alias less='less -r'
alias rm='rm -I'
alias gcc='gcc -Wall'

## Utility Tools
alias wclone='wget --mirror --convert-links --adjust-extension --page-requisites --show-progress'
alias update='brew update && brew upgrade && zinit update'
alias py='python3'
alias stow='stow -v'
alias sizeof='du -hs'
alias storage="dust -rC | bat --file-name 'Storage Breakdown'"
alias wordcount="wc -w"

if (( IS_MACOS )); then
    alias colors='terminal_colors.sh' 
    alias battery='system_profiler SPPowerDataType | grep -E "Cycle Count|Condition|Maximum Capacity" | bat' 
fi

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

## Help Output Formatting
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

## SSH Connections
CALCULON="192.168.0.155"

alias morbius='clear && ssh schristensen34@morbius.mscsnet.mu.edu'
alias helotrix="clear && ssh -t schristensen34@helotrix.mscsnet.mu.edu 'export TERM=xterm-256color; exec zsh'"
alias calculon="clear && ssh -t sccmp@$CALCULON 'export TERM=xterm-256color; exec zsh'"
alias eldrad="clear && ssh -t schristensen34@eldrad.mscsnet.mu.edu 'exec bash; echo use wake and kill'"

# ================== ERROR CHECK ==================

if (( ZSHRC_ERR )); then
  LOGIN_ACTION="none"
  echo "\033[91mzsh initialization encountered an error. code: $ZSHRC_ERR\033[0m"
fi

# =================== LOGIN ACTIONS ===================
case "$LOGIN_ACTION" in
  "hostname-pretty")
    clear
    hostname | \grep -E -o '^[^.]+' | figlet -c -w $COLUMNS | lolcat -f
    echo "\n\033[90mUse 'help'\033[0m"
    ;;
  "hostname-basic")
    clear
    hostname | \grep -E -o '^[^.]+' | xargs echo -e "\033[93mMachine: "
    echo "\033[0m"
    echo "\n\033[90mUse 'help'\033[0m"
    ;;
  "quote-tame")
    clear
    quote_size=$(( (COLUMNS * 3) / 4))
    fortune -s | cowthink -f ${COWSAY_CHOICE} -W ${quote_size}
    echo "\n\033[90mUse 'help'\033[0m"
    ;;
  "quote-nsfw")
    clear
    quote_size=$(( (COLUMNS * 3) / 4))
    fortune -as | cowthink -f ${COWSAY_CHOICE} -W ${quote_size}
    echo "\n\033[90mUse 'help'\033[0m"
    ;;
  "none")
    ;;
  *)
    echo "\033[91mLogin action not supported ($LOGIN_ACTION)\033[0m"
    ;;
esac

