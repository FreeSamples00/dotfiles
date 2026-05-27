# ----- Env Variables -----

$env.LESS = "-R -f"

$env.XDG_CONFIG_HOME = $"($env.home)/.config"
$env.XDG_CACHE_HOME = $"($env.home)/.cache"
$env.nu_config_dir = $"($env.XDG_CONFIG_HOME)"
$env.nu_module_dir = $"($env.nu_config_dir)/nushell/modules"
$env.nu_confs_dir = $"($env.nu_config_dir)/nushell/confs"
$env.NU_LIB_DIRS ++= [$env.nu_module_dir $env.nu_confs_dir]

$env.config.buffer_editor = "nvim"
$env.EDITOR = "nvim"

$env.ZELLIJ_CONFIG_DIR = $"($env.XDG_CONFIG_HOME)/zellij"

$env.OPENCODE_ENABLE_EXA = 1

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
  zoxide init nushell --cmd z | save -f ~/.cache/nushell/zoxide.nu
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
