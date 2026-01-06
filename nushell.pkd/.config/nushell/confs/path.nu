# Read paths stored in /etc/paths.d and /etc/paths

$env.PATH = (
    $env.PATH
    | append (open --raw /etc/paths | lines)
    | append (glob /etc/paths.d/** --no-dir | each { open --raw $in | lines } | flatten)
    | uniq
)
