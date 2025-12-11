# ==================== FZF ====================

if (( $+commands[fzf] )); then
  # Disable file and cd widgets before eval
  export FZF_CTRL_T_COMMAND=''
  export FZF_ALT_C_COMMAND=''

  eval "$(fzf --zsh)"
  export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
  export FZF_DEFAULT_OPTS='--height 50% --layout=default --border --color=fg:7,bg:-1,hl:3,fg+:15,bg+:8,hl+:11,info:6,prompt:4,pointer:5,marker:2,spinner:6,header:4'

  # fzf-tab styling - inherit colors from FZF_DEFAULT_OPTS
  zstyle ':fzf-tab:*' fzf-flags --color=fg:7,bg:-1,hl:3,fg+:15,bg+:8,hl+:11,info:6,prompt:4,pointer:5,marker:2,spinner:6,header:4
  if (( $+commands[bat] )) && (( $+commands[eza] )); then
    zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -d ${(Q)realpath} ]] && eza --tree --level=1 --sort=modified --reverse --follow-symlinks --dereference --color=always ${(Q)realpath} || bat --color=always --line-range :500 -p ${(Q)realpath}'
  elif (( $+commands[bat] )); then
    zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -d ${(Q)realpath} ]] && \ls -AtL --color=always ${(Q)realpath} || bat --color=always --line-range :500 ${(Q)realpath}'
  else
    zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -d ${(Q)realpath} ]] && \ls -AtL --color=always ${(Q)realpath} || cat ${(Q)realpath}'
  fi
fi
