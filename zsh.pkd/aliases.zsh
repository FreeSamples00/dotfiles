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

if (which tree >/dev/null); then
  alias tree='tree -aC -I .git -I .venv -I "._*"'
fi

if (which eza >/dev/null); then
  alias ls='eza --color=automatic --icons=automatic --no-user -a --group-directories-first --sort=type -I="._*"'
else
  alias ls='ls -A --color=automatic'
fi

if (which bat >/dev/null); then
  alias cat="bat -p"
  if (which dust >/dev/null); then
    alias storage="dust -rC | bat --file-name 'Storage Breakdown'"
  fi
fi

if (which btop >/dev/null); then
  alias top='btop -p 0'
  alias ntop='btop -p 2'
  alias ptop='btop -p 1'
fi

if (which delta >/dev/null); then
  alias diff='delta --side-by-side'
fi

if (which gcc >/dev/null); then
  alias gcc='gcc -Wall'
fi

if (which wget >/dev/null); then
  alias wclone='wget --mirror --convert-links --adjust-extension --page-requisites --show-progress'
fi

if (which mdpdf >/dev/null); then
  alias 2pdf='mdpdf --ghstyle=true --border 0.5in'
fi

if (which hyperfine >/dev/null); then
  alias bench='hyperfine'
fi

if (which ttyc >/dev/null); then
  alias colors="echo -e '\033[93mUse ttyc\033[0m'; ttyc"
fi

if (which copy >/dev/null); then
  alias copylast='fc -ln -1 | tr -d "\n" | copy'
  alias cwd='pwd | copy'
fi

if (which lazygit >/dev/null); then
  alias lg='lazygit'
fi

if (which git >/dev/null); then
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

if (which tldr >/dev/null); then
  function man+ {
    tldr "$@" | ${PAGER:-less}
  }
fi

if (which transmission-cli >/dev/null); then
  alias torrent="transmission-cli"
fi
