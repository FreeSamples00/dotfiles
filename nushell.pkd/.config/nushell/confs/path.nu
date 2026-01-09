let path_additions = [
  "~/.cargo/bin"
  "~/dotfiles/scripts/in_path"
]

$env.PATH = (
  $env.PATH
  | append ($path_additions | where { $in | path expand | path exists })
  | append (if ("/etc/paths" | path exists) { open --raw /etc/paths | lines | where { path exists } } else { [] })
  | append (glob /etc/paths.d/** --no-dir | each { open --raw $in | lines } | flatten | where { $in | path expand | path exists })
  | uniq
)
