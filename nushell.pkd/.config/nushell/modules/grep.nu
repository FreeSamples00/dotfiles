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

def colorize [
  text: string
  start: int
  end: int
] {
  let prefix = if (($start - 1) < 0) {""} else {$text | str substring 0..($start - 1)}
  let match_text = $text | str substring $start..($end - 1)
  let suffix = $text | str substring $end..
  $"($prefix)(ansi $highlight_color)($match_text)(ansi reset)($suffix)"
}

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

# Grep tool that emits structured output for nushell.
#
# Searches standard input for a pattern using ripgrep and returns structured matches.
#
# Example
#
#   Search for lines containing "error" in file.txt:
#   `open file.txt | grep "error"`
#
#   Search for "fix" in git log without ansi colors:
#   `git log | grep "fix" --raw`
#
# Subcommands
#
#   `grep` - searches stdin (this command)
#   `grep all` - recursively searches file contents
#   `grep file` - recursively searches file names
export def main [
  pattern: string
  --raw (-r) # no ansi colors
  --json (-j) # output results in json format
]: string -> table<line: int, match: string> {
  let stdin = $in
  if ($stdin == null) {
    print $"(ansi red)ERR: No stdin passed."
    return
  }

  $stdin | rg $pattern --json
  | from json -o
  | where type == "match"
  | get data
  | each {|match|
    mut line = $match.lines.text
    if (not $raw) {
      for span in ($match.submatches | sort-by start -r) {
        $line = colorize $line $span.start $span."end"
      }
      $line = $"(ansi reset)($line)" # possibly fucks with spacing
    }
    {
      line: ($match.line_number)
      match: ($line | str trim)
    }
  }
  | if $json {
    to json
  } else {
    $in
  }
}

# Recursively searches file contents for a pattern.
#
# Uses ripgrep to search files in the current directory and subdirectories.
# Returns structured output with file path, line number, and matched content.
#
# Example
#
#   Search all files for "TODO":
#   `grep all "TODO"`
#
#   Search .nu files for "function" up to 3 directories deep:
#   `grep all "function" --type nu -d 3`
export def all [
  pattern: string # pattern to search for
  --type (-t): string@rg_type_completer # filetype to search in
  --depth (-d): int = 999 # max depth to search
  --raw (-r) # no ansi colors
  --json (-j) # output in json
]: nothing -> table<file: string, line: int, match: string> {
  if (which rg | length) == 0 {
    print $"(ansi red)ERR: ripgrep \(rg\) not found."
    return
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
        $line = colorize $line $span.start $span."end"
      }
      $line = $"(ansi reset)($line)" # possibly fucks with spacing
    }
    {
      name: ($match.path.text | str trim)
      line: ($match.line_number)
      match: ($line | str trim)
    }
  }
  | if $json {
    to json
  } else {
    $in | metadata set --datasource-ls
  }
}

# Recursively searches file and directory names for a pattern.
#
# Uses fd to find files/directories matching a pattern in the current
# directory and subdirectories. Returns structured file information.
#
# Example
#
#   Find all files/directories containing "config" in the name:
#   `grep file "config"`
#
#   List all directories with detailed information:
#   `grep file --type dir --long`
export def file [
  --depth (-d): int = 999 # max depth to search
  --type (-t): string@fd_type_completer # file types to search for
  --long (-l) # show detailed file info
  --json (-j) # output in json
  pattern?: string # pattern to search for
]: nothing -> table {

  if (which fd | length) == 0 {
    print $"(ansi red)ERR: fd not found."
    return
  }

  let fd_defaults = if ($type != null) {$fd_defaults | append $"--type=($type)"} else {$fd_defaults}
  let pattern = $pattern | default ""

  fd ...$fd_defaults --max-depth $depth $pattern
  | lines
  | par-each --keep-order {|file|
    if ($long) {
      ls $file --directory --du --long
    } else {
      ls $file --directory --du
    }
    | update type {|| mime ($file | ansi strip) }
  } | flatten
  | if $json {
    to json
  } else {
    $in | metadata set --datasource-ls # adds ls metadata for table --icons
  }
}
