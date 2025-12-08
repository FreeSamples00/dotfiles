# ==================== ALIASES ====================

# ---------- STATIC ----------

alias reload='\clear && exec zsh'
alias update='brew update && brew upgrade && brew cleanup; zinit update'

alias grep='grep -i --color=auto'
alias grepa='grep -Rni --exclude-dir={.bzr,cvs,.git,.hg,.svn,.idea,.tox,.venv,venv}'
alias grepf='find . | \grep -i --color=always'
alias grepd='find . -type d | grep -i'

alias '?'='echo $?'
alias less='less -R'
alias rm='rm -I'
alias sizeof='du -hs'

# ---------- CONDITIONAL ----------

if (( $USE_ENHANCED_CLEAR )); then
  shell_source enhanced_clear
else
  alias c="clear"
  alias cls="clear && ls"
fi

if (( $+commands[tree] )); then
  alias tree='tree -aC -I .git -I .venv -I "._*"'
fi

if (( $+commands[eza] )); then
  alias ls='eza --color=automatic --icons=automatic --no-user -a --group-directories-first --sort=type -I="._*"'
else
  alias ls='ls -A --color=automatic'
fi

if (( $+commands[bat] )); then
  alias cat="bat -p"
  if (( $+commands[dust] )); then
    alias storage="dust -rC | bat --file-name 'Storage Breakdown'"
  fi
fi

if (( $+commands[btop] )); then
  alias top='btop -p 0'
  alias ntop='btop -p 2'
  alias ptop='btop -p 1'
fi

if (( $+commands[delta] )); then
  if (( $+commands[bat] )); then
    alias diff='delta --side-by-side --pager "bat -p"'
  else
    alias diff='delta --side-by-side --pager "less -R"'
  fi
fi

if (( $+commands[gcc] )); then
  alias gcc='gcc -Wall'
fi

if (( $+commands[wget] )); then
  alias wclone='wget --mirror --convert-links --adjust-extension --page-requisites --show-progress'
fi

if (( $+commands[mdpdf] )); then
  alias 2pdf='mdpdf --ghstyle=true --border 0.5in'
fi

if (( $+commands[hyperfine] )); then
  alias bench='hyperfine'
fi

if (( $+commands[ttyc] )); then
  alias colors="echo -e '\033[93mUse ttyc\033[0m'; ttyc"
fi

if (( $+commands[copy] )); then
  alias copylast='fc -ln -1 | tr -d "\n" | copy'
  alias cwd='pwd | copy'
fi

if (( $+commands[lazygit] )); then
  alias lg='lazygit'
fi

if (( $+commands[git] )); then
  function gi() { curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$@ ;}
  alias gst='git status'
  alias gl='git pull'
  alias gp='git push'
  alias gf='git fetch'
  alias gc='git commit --verbose'
  alias gcm='git commit -m'
  alias gca='git commit --verbose --all'
  alias ga='git add'
  alias grmc='git rm --cached'
  alias yubi-git='GIT_SSH_COMMAND="ssh -i $PWD/id_ed25519_sk_rk" git'
fi

if (( $+commands[tldr] )); then
  function man+ {
    tldr --color "$@" | less -R +g
  }
fi

if (( $+commands[transmission-cli] )); then
  alias torrent="transmission-cli"
fi
