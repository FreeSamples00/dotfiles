# ==== NEOVIM ====

alias e="nvim"

function eg() {
    ( "$GUI_EDITOR" "$@" >/dev/null 2>&1 & )
}

# Note: Completions for editors are handled externally
