# ==== NEOVIM ====

alias e="nvim"

function eg() {
    ( "$GUI_EDITOR" "$@" >/dev/null 2>&1 & )
}

compdef e _files
compdef eg _files

# Note: Completions for editors are handled externally
