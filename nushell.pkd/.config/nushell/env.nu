# ----- Env Variables -----

$env.LESS = "-R -f"

if not (which bat | is-empty) {
  $env.PAGER = "bat"
  $env.MANPAGER = if $nu.os-info.name == 'macos' {
    # macOS: BSD nroff emits backspace-overstrike; col -bx strips it before bat
    "sh -c 'col -bx | bat -l man -p'"
  } else {
    # Linux: GNU groff -Tutf8 emits ANSI SGR (no overstrike); col strips ESC and
    # mangles it (4mBAT24m), so strip SGR with sed and let bat apply the theme
    "sh -c 'sed \"s/\\x1b\\[[0-9;]*m//g\" | bat -l man -p'"
  }
}

$env.XDG_CONFIG_HOME = $"($env.home)/.config"
$env.XDG_CACHE_HOME = $"($env.home)/.cache"
$env.nu_config_dir = $"($env.XDG_CONFIG_HOME)"
$env.nu_module_dir = $"($env.nu_config_dir)/nushell/modules"
$env.nu_confs_dir = $"($env.nu_config_dir)/nushell/confs"
$env.NU_LIB_DIRS ++= [$env.nu_module_dir $env.nu_confs_dir]

$env.config.buffer_editor = "nvim"
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"

$env.ZELLIJ_CONFIG_DIR = $"($env.XDG_CONFIG_HOME)/zellij"

$env.OPENCODE_ENABLE_EXA = 1

# Restore COLORTERM over SSH (Ghostty sets this locally but it's not forwarded)
if ($env.TERM | str contains "ghostty") and ($env.COLORTERM? | is-empty) {
  $env.COLORTERM = "truecolor"
}

# ----- External Configs -----
$env.dependencies = [
  starship
  zoxide
  carapace
]

mkdir ~/.cache/nushell

if not (which starship | is-empty) {
  starship init nu | save -f ~/.cache/nushell/starship.nu
}
if not (which zoxide | is-empty) {
  zoxide init nushell --no-cmd | save -f ~/.cache/nushell/zoxide.nu
}
if not (which carapace | is-empty) {
  carapace _carapace nushell | save -f ~/.cache/nushell/carapace.nu
}
if not (which just | is-empty) {
  $env.JUST_COMPLETE_ALIASES = 'true'
  $env.JUST_COMMAND_COLOR = 'black'
  $env.JUST_EXPLAIN = 'true'
  $env.JUST_UNSORTED = 'true'
  just --completions nushell | save -f ~/.cache/nushell/just.nu
}

$env.SHELL = "/bin/bash" # set shell to bash for tools that need it
