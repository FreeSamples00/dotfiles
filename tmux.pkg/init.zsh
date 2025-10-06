# ==================== TMUX ====================

function tmuxn() {
  if [[ "$1" != "" ]]; then
    command tmux new-session -s $1 "exec zsh"
  else
    command tmux new-session "exec zsh"
  fi
}

function tmuxa() {
  if [[ "$1" == "" ]]; then
    command tmux attach
  else
    command tmux attach -t "$1"
  fi
}

alias tmuxk="tmux kill-session"
alias tmuxl="tmux ls"
alias tmuxd="tmux detach"

