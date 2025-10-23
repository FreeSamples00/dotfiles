# ==================== ALIASES ====================

if (( $USE_ENHANCED_CLEAR )); then
  shell_source enhanced_clear
else
  alias c="clear"
  alias cls="clear && ls"
  alias ctr="clear && tree"
fi

alias config="$EDITOR ~/dotfiles/zsh.pkg"
alias reload='clear && exec zsh'
alias update='brew update && brew upgrade && brew cleanup; zinit update'

alias tree='tree -aC -I .git -I .venv'
alias cwd='pwd | copy'
alias ls='eza --color=automatic --icons=automatic --no-user -a --group-directories-first --sort=type'

# ==== grep aliases ====
alias grep='grep -i --color=auto'
alias grepa='grep -Rni --exclude-dir={.bzr,cvs,.git,.hg,.svn,.idea,.tox,.venv,venv}'
alias grepf='find . | \grep -i --color=always'
alias grepd='find . -type d | grep -i'
alias grepb='brew list | \grep --color=always'

alias '?'='echo $?'

alias cat="bat -p"

alias top='btop -p 0'
alias ntop='btop -p 2'
alias ptop='btop -p 1'

alias diff='delta --side-by-side'

alias less='less -R'
alias rm='rm -I'
alias gcc='gcc -Wall'

alias sizeof='du -hs'
alias storage="dust -rC | bat --file-name 'Storage Breakdown'"

alias wclone='wget --mirror --convert-links --adjust-extension --page-requisites --show-progress'
alias 2pdf='mdpdf --ghstyle=true --border 0.5in'
alias bench='hyperfine'

alias colors="echo -e '\033[93mUse ttyc\033[0m'; ttyc"

alias copylast='fc -ln -1 | tr -d "\n" | pbcopy'

# ==== git aliases ====
alias gi='git-ignore'
alias lg='lazygit'

alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias gf='git fetch'
alias gc='git commit --verbose'
alias gcm='git commit -m'
alias gca='git commit --verbose --all'
alias ga='git add'
alias grmc='git rm --cached'
