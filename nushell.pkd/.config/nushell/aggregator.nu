# ----- Shell Tools -----
use ~/.cache/nushell/starship.nu
source ~/.cache/nushell/zoxide.nu
source ~/.cache/nushell/carapace.nu

# ----- Configs -----

source path.nu
source completers.nu
source functions.nu
source shorthands.nu

# ---- Modules ----
use grep.nu
use clipboard.nu *
use git.nu *
use synthetic.nu
use APIs.nu *
use tmx.nu

use (if $nu.os-info.name == 'macos' { 'macos.nu' }) *
