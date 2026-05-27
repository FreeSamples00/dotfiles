# ----- Shell Tools -----
use ~/.cache/nushell/starship.nu
source ~/.cache/nushell/zoxide.nu
source ~/.cache/nushell/carapace.nu
source ~/.cache/nushell/just.nu

# ----- Configs -----

source path.nu
source completers.nu
source misc.nu

# ---- Modules ----
use shell-helpers.nu *
use grep.nu
use clipboard.nu *
use git.nu *
use synthetic.nu
use APIs.nu *
use tmx.nu
use dexcom.nu
use zellij.nu

use (if $nu.os-info.name == 'macos' { 'macos.nu' }) *
