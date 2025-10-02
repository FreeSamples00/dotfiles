# ==================== ALIASES ====================

if (( $USE_ENHANCED_CLEAR )); then
  shell_source enhanced_clear
else
  alias c="clear"
  alias cls="clear && ls"
  alias ctr="clear && tree"
fi

alias config="$EDITOR ~/.zshrc"
alias reload='clear && exec zsh'

alias tree='tree -aC -I .git -I .venv'
alias cwd='pwd | copy'
alias ls='eza --color=automatic --icons=automatic --no-user -a --group-directories-first --sort=type'

alias grep='grep -ni --color=auto --exclude-dir={.bzr,cvs,.git,.hg,.svn,.idea,.tox,.venv,venv}'
alias grepa='grep -Rni --exclude-dir={.bzr,cvs,.git,.hg,.svn,.idea,.tox,.venv,venv}'
alias grepf='find . | grep -i'
alias grepd='find . -type d | rg -iu'

alias '?'='echo $?'

alias gi='git-ignore'
alias lg='lazygit'

alias cat="bat -p"

alias top='btop -p 0'
alias ntop='btop -p 2'
alias ptop='btop -p 1'

alias diff='delta --side-by-side'

alias less='less -R'
alias rm='rm -I'
alias gcc='gcc -Wall'

alias update='brew update && brew upgrade && brew cleanup; zinit update'

alias sizeof='du -hs'
alias storage="dust -rC | bat --file-name 'Storage Breakdown'"

alias wclone='wget --mirror --convert-links --adjust-extension --page-requisites --show-progress'
alias colors='terminal_colors.sh'
alias 2pdf='mdpdf --ghstyle=true --border 0.5in'
alias bench='hyperfine'

