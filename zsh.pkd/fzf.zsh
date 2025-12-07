# ==================== FZF ==================== 

if (which fzf >/dev/null); then
  eval "$(fzf --zsh)"
  export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
  export FZF_DEFAULT_OPTS='--height 50% --layout=default --border --color=hl:#2dd4bf'
  
  # Disable ctrl+t and alt+c keybindings
  bindkey -r '^T'  # Remove ctrl+t (fzf-file-widget)
  bindkey -r '\ec' # Remove alt+c (fzf-cd-widget)
  
  # fzf-tab styling
  zstyle ':fzf-tab:*' fzf-flags --color=fg:7,bg:-1,hl:3,fg+:15,bg+:8,hl+:11,info:6,prompt:4,pointer:5,marker:2,spinner:6,header:4
  if (which bat >/dev/null) && (which eza >/dev/null); then
    zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -d ${(Q)realpath} ]] && eza --tree --level=1 --sort=modified --reverse --follow-symlinks --dereference --color=always ${(Q)realpath} || bat --color=always --line-range :500 -p ${(Q)realpath}'
  elif (which bat >/dev/null); then
    zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -d ${(Q)realpath} ]] && \ls -AtL --color=always ${(Q)realpath} || bat --color=always --line-range :500 ${(Q)realpath}'
  else
    zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -d ${(Q)realpath} ]] && \ls -AtL --color=always ${(Q)realpath} || cat ${(Q)realpath}'
  fi
fi
