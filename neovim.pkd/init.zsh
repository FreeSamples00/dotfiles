# ==== NEOVIM ====

alias e="nvim"
compdef _files e

function eg() {
    ( "$GUI_EDITOR" "$@" >/dev/null 2>&1 & )
}
compdef _files eg
