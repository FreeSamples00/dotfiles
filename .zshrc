# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

fpath=(~/bin/wd $fpath) # wd auocomplete
zinit light mfaerevaag/wd
zinit light laggardkernel/git-ignore

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# custom snippets
zinit snippet OMZP::colorize
zinit snippet OMZP::git
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::git
zinit snippet OMZP::safe-paste
zinit snippet OMZP::git-auto-fetch
zinit snippet OMZP::zbell
zinit snippet OMZP::ssh


# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='micro'
else
  export EDITOR='micro'
fi

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# shorten prompt length
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=""

# History
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

# keybinds
bindkey '^[[1;5D' beginning-of-line  # Ctrl+Left
bindkey '^[[1;5C' end-of-line        # Ctrl+Right
bindkey '^[^[[D' backward-word       # Opt+Left
bindkey '^[^[[C' forward-word        # Opt+Right
#bindkey '^[[1;2D' vi-backward-char   # Shift+Left
#bindkey '^[[1;2C' vi-forward-char    # Shift+Right


# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim='nvim'

# =================== ALIASES ===================

HELP_PATH="/usr/local/src/common/help_msg.txt"

## Terminal settings / manipulation
alias config='micro ~/.zshrc'
alias edit_help='sudo micro ${HELP_PATH}'
alias help='ccat ${HELP_PATH} | less -r'
alias reload='clear && exec zsh'


## App Launches
#alias typora='open -a typora'
alias typora="/Applications/Typora.app/Contents/MacOS/Typora"
alias spf='spf -pld'
alias vsc='code'
alias mi='micro'


## Terminal QOL
alias copy='pbcopy'
alias paste='pbpaste'
alias cwd='pwd | copy'

alias grep='grep -i --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv}'
alias grepa='grep -Rni --color=auto'
alias grepf='find . | grep -i --color=auto'
alias greph='rg --passthru'

alias colors='terminal_colors.sh'
alias morbius='morbius.sh'
alias py='python3'
alias dabox='dabox.sh'
alias ql='quick-look'
alias info="neofetch"
alias getlast='echo $?'
alias manp='man-preview'
alias sizeof='du -hs'
alias ofd='pwd | xargs open -R'

## git
alias ignore='micro ./.gitignore'
alias gitree='git log --oneline --graph --color --all --decorate'
alias gi='git-ignore'


## command replacements
alias top='htop'
alias diff='delta --side-by-side'

## Tag additions to commands
alias less='less -r'
alias rm='rm -I'
alias gcc='gcc -Wall'


# ================== RUN ON LOGIN ==================
clear
quote_size=$(( (COLUMNS * 3 + 1) / 4 ))  # gets 3/4s of terminal width
#echo "Cowthink wrap size: ${quote_size}"
fortune -as | cowthink -f tux -W ${quote_size}
echo "\n\033[90mUse 'help'\n\033[0m"

# Shell integrations
eval "$(fzf --zsh)"
