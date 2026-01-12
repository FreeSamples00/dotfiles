# ----- Shell Tools -----
use ~/.cache/nushell/starship.nu
source ~/.cache/nushell/zoxide.nu

# ----- Configs -----

source path.nu
source completers.nu
source commands.nu
source command_aliases.nu
source structure_wrappers.nu

# TODO: modules go here?

source aliases.nu
source completions.nu

# ---- Modules ----
use grep.nu
use clipboard.nu *
use git.nu *
use synthetic.nu
