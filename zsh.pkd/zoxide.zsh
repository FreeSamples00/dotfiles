# ==================== ZOXIDE ====================

if (which zoxide >/dev/null); then
  unalias zi # zi is zinit by default
  eval "$(zoxide init zsh)"
  alias cd='z'
  alias zd='zi'
fi
