# ----- Constants ----
const GREP_IGNORE = [ **/.git/** **/.venv/** **/__pycache__/** **/.cache/** **/node_modules/** */]

# ----- Files -----

# TODO: add mime typing to ls -l or similar?

# Mime the type of a file
def mime [
  file: path # File to mime the type of
  --full (-f) # Show full mimed type (**/** vs **)
]: nothing -> string {
  ^file --mime-type -b $file | str trim
  | if $full { $in
  } else {$in
    match $in {
      "application/octet-stream" => "binary"
      "text/plain" => "text"
      "inode/x-empty" => "empty"
      "inode/directory" => "dir"
      $other => ($other | split row '/' | get 1 | str trim)
    }
  }
}

# TODO: create a tree command that nests filepaths

# ----- Grepping -----

# Recursively search text file contents
def grepa [
  pattern: string # Regex pattern
  --no-color (-n) # Disable colored output
  --enumerate (-e)  # Enumerate output
  --depth (-d): int = 999 # Directory depth to descend (1 is current)
  --ignore (-i): list<string> # Patterns to ignore in paths (glob pattern, use `*text*` to match all paths containing `text`)
]: nothing -> table<index: int, file: string, lineno: int, match: string> {
  let ignore_pattern = ( $ignore | each { $"**/($in)/**" } ) | append $GREP_IGNORE
  glob **/* --exclude $ignore_pattern --depth $depth --no-dir --follow-symlinks
  | path relative-to (pwd)
  | par-each { |file|
      try {
        open --raw $file
        | lines
        | enumerate
        | where { $in.item =~ $pattern }
        | if $no_color {
            each {{
              file: $file,
              line: ( $in.index + 1 ),
              match: $in.item
            }}
          } else {
            each {{
              file: ($file | str replace -ra "(.*/)" $"(ansi grey46)$1(ansi reset)"),
              line: ($in.index + 1),
              match: ($in.item | str replace -ra $"\(($pattern)\)" $"(ansi red_bold)$1(ansi reset)")
            }}
          }
      } catch {[]}
    }
  | flatten
  | sort-by -n file line
  | if $enumerate { enumerate | flatten } else {$in}
}


# Recursively search filenames
def grepf [
  pattern: string # Regex pattern
  --no-color (-n) # Disable colored output
  --enumerate (-e)  # Enumerate output
  --depth (-d): int = 999 # Directory depth to descend (1 is current)
  --ignore (-i): list<string> # Patterns to ignore in paths (glob pattern, use `*text*` to match all paths containing `text`)
# ]: nothing -> table<index: int, name: string, type: string, size: filesize, modified: datetime> {
] {
  let ignore_pattern = ( $ignore | each { $"**/($in)/**" } ) | append $GREP_IGNORE
  glob **/* --exclude $ignore_pattern --depth $depth --no-dir --follow-symlinks
  | path relative-to (pwd)
  | where ($it | path basename) =~ $pattern
  | par-each { |file|
    | ls --mime-type $file
    | update type {mime $file}
    | if $no_color {$in} else {
        update name {str replace -ra "(.*/)" $"(ansi grey46)$1(ansi reset)"}
      }
    }
  | flatten
  | if $enumerate { enumerate | flatten } else {$in}
}


# Recursively search directory names
def grepd [
  pattern: string # Regex pattern
  --no-color (-n) # Disable colored output
  --enumerate (-e)  # Enumerate output
  --depth (-d): int = 999 # Directory depth to descend (1 is current)
  --ignore (-i): list<string> # Patterns to ignore in paths
]: nothing -> table<index: int, name: string, size: filesize, modified: datetime> {
  let ignore_pattern = ( $ignore | each { $"**/($in)/**" } ) | append $GREP_IGNORE
  glob **/* --exclude $ignore_pattern --depth $depth --no-file --follow-symlinks
  | where $it != (pwd)
  | where ($it | path basename) =~ $pattern
  | path relative-to (pwd)
  | par-each { |file|
      ls -D $file
      | update size (du $file | get physical | first)
    }
  | flatten
  | if $no_color {$in} else {
      update name {str replace -ra "(.*/)" $"(ansi grey46)$1(ansi reset)"}
    }
  | select name size modified
  | if $enumerate { enumerate | flatten } else {$in}
}
