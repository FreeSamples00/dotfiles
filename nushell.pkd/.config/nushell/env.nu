# ----- Env Variables -----

$env.config.buffer_editor = "nvim"

# ----- External Configs -----
mkdir ~/.cache/nushell

starship init nu | save -f ~/.cache/nushell/starship.nu
zoxide init nushell --cmd z | save -f ~/.cache/nushell/zoxide.nu
carapace _carapace nushell | save -f ~/.cache/nushell/carapace.nu

# ----- Variables for External Use -----

$env.SHELL = "/bin/bash" # used by opencode
