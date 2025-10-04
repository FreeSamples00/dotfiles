# ==================== ENCHANCED CLEAR ====================

function enhanced_clear() {
  local PROMPT_SIZE=5
  if [[ "$TMUX" != "" ]]; then
    clear
    return
  fi

  for _ in {$PROMPT_SIZE..$LINES}; do
    echo ""
  done

  printf $'\e[H\e[J'
}

alias clear="enhanced_clear"
alias c="enhanced_clear"
alias cls="echo '\n' && enhanced_clear && echo && ls"
alias ctr="echo "\n" && enhanced_clear && tree"
