$env.config.buffer_editor = "nvim"

# ----- Starship Prompt -----
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

# ----- Zoxide Init -----
zoxide init nushell | save -f ~/.cache/zoxide.nu
