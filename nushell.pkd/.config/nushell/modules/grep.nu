const highlight_color = "light_red_bold"

const fd_defaults = [
  --no-ignore-vcs
  --color always
  --hidden
  --ignore-case
  --follow
]

const rg_defaults = [
  --crlf
  --smart-case
  --hidden
  --no-ignore-vcs
  --color=always
  --json
]

const rg_types = [
  --type-add 'nu:*.nu'
]

def rg_type_completer [] {
  rg ...$rg_types --type-list | parse "{value}: {description}"
}

def fd_type_completer [] {
  [
    {value: "file", description: "regular files"}
    {value: "dir", description: "directories"}
    {value: "symlink", description: "symbolic links"}
    {value: "socket", description: "sockets"}
    {value: "pipe", description: "named pipes (FIFOs)"}
    {value: "block-device", description: "block devices"}
    {value: "char-device", description: "character devices"}
    {value: "executable", description: "executables"}
    {value: "empty", description: "empty files or directories"}
  ]
}

export def all [
  pattern: string # pattern to search for
  --type (-t): string@rg_type_completer # filetype to search in
  --depth (-d): int = 999 # max depth to search
  --raw (-r) # no ansi colors
] {

  if (which rg | length) == 0 {
    print $"(ansi red)ERR: ripgrep \(rg\) not found."
    return
  }

  let color = {|text: string, start: int, end: int|
    let prefix = if (($start - 1) < 0) {""} else {$text | str substring 0..($start - 1)}
    let match_text = $text | str substring $start..($end - 1)
    let suffix = $text | str substring $end..
    $"($prefix)(ansi $highlight_color)($match_text)(ansi reset)($suffix)"
  }

  let rg_defaults = if ($type != null) {$rg_defaults | append $"--type=($type)"} else {$rg_defaults}

  rg $pattern ...$rg_defaults ...$rg_types --max-depth=($depth)
  | from json -o
  | where type == "match"
  | get data
  | each {|match|
    mut line = $match.lines.text
    if (not $raw) {
      for span in ($match.submatches | sort-by start -r) {
        $line = do $color $line $span.start $span."end"
      }
      $line = $"(ansi reset)($line)" # possibly fucks with spacing
    }
    {
      file: ($match.path.text | str trim)
      line: ($match.line_number)
      match: ($line | str trim)
    }
  }
}

export def file [
  --depth (-d): int = 999 # max depth to search
  --long (-l) # show detailed file info
  --type (-t): string@fd_type_completer # file types to search for
  pattern?: string # pattern to search for
] {

  if (which fd | length) == 0 {
    print $"(ansi red)ERR: fd not found."
    return
  }

  let fd_defaults = if ($type != null) {$fd_defaults | append $"--type=($type)"} else {$fd_defaults}
  let pattern = $pattern | default ""

  fd ...$fd_defaults --max-depth $depth $pattern
  | lines
  | par-each {|file|
    if ($long) {
      ls $file --directory --du --long
    } else {
      ls $file --directory --du
    }
    | update type {|| mime ($file | ansi strip) }
  } | flatten
}
