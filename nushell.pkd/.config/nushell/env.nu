# ----- Env Variables -----

$env.config.buffer_editor = "nvim"
$env.nu_config_dir = $"($env.XDG_CONFIG_HOME)"
$env.nu_module_dir = $"($env.nu_config_dir)/nushell/modules"
$env.nu_confs_dir  = $"($env.nu_config_dir)/nushell/confs"
$env.NU_LIB_DIRS ++= [ $env.nu_module_dir $env.nu_confs_dir ]

# ----- External Configs -----
mkdir ~/.cache/nushell

if not (which starship | is-empty) {starship init nu | save -f ~/.cache/nushell/starship.nu}
if not (which zoxide | is-empty) {zoxide init nushell --cmd z | save -f ~/.cache/nushell/zoxide.nu}
if not (which carapace | is-empty) {carapace _carapace nushell | save -f ~/.cache/nushell/carapace.nu}

# ----- Variables for External Use -----

$env.SHELL = "/bin/bash" # used by opencode
