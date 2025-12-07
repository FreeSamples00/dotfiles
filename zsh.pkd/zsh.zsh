# ==================== ZSH ====================

# ==== COMPLETIONS ====
autoload -Uz compinit && compinit
zinit cdreplay -q

# Completion styling.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-flags --color=fg:7,bg:-1,hl:3,fg+:15,bg+:8,hl+:11,info:6,prompt:4,pointer:5,marker:2,spinner:6,header:4
if (which bat >/dev/null) && (which eza >/dev/null); then
  zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -d ${(Q)realpath} ]] && eza --tree --level=1 --sort=modified --reverse --follow-symlinks --dereference --color=always ${(Q)realpath} || bat --color=always --line-range :500 ${(Q)realpath}'
elif (which bat >/dev/null); then
  zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -d ${(Q)realpath} ]] && \ls -AtL --color=always ${(Q)realpath} || bat --color=always --line-range :500 ${(Q)realpath}'
else
  zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -d ${(Q)realpath} ]] && \ls -AtL --color=always ${(Q)realpath} || cat ${(Q)realpath}'
fi

# ==== HISTORY ====

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
