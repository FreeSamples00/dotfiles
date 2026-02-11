# ----- Shell Tools -----
if not (which starship | is-empty) {use ~/.cache/nushell/starship.nu}
if not (which zoxide | is-empty) {source ~/.cache/nushell/zoxide.nu}
if not (which carapace | is-empty) {source ~/.cache/nushell/carapace.nu}

# ----- Configs -----

source path.nu
source completers.nu
source functions.nu
source shorthands.nu
source completions.nu

# ---- Modules ----
use grep.nu
use clipboard.nu *
use git.nu *
use synthetic.nu
use APIs.nu *
use tmx.nu
