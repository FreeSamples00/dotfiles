const GREP_IGNORE = [
  # Version control
  **/.git/** **/.svn/** **/.hg/**
  # Python
  **/.venv/** **/__pycache__/** **/*.pyc **/*.pyo **/.pytest_cache/** **/dist/** **/build/** **/*.egg-info/**
  # JavaScript/Node
  **/node_modules/** **/dist/** **/build/** **/.next/** **/.nuxt/**
  # Rust
  **/target/** **/*.rs.bk **/Cargo.lock
  # Go
  **/vendor/**
  # Java/JVM
  **/target/** **/*.class **/.gradle/** **/build/**
  # .NET/C#
  **/bin/** **/obj/** **/*.dll **/*.exe
  # C/C++
  **/*.o **/*.so **/*.a **/*.out
  # Ruby
  **/.bundle/** **/vendor/bundle/**
  # PHP
  **/vendor/**
  # General
  **/.cache/** **/.DS_Store **/Thumbs.db
]

# Grep utilities for recursive searching
#
# Available commands:
#   grep all    - Search within file contents
#   grep file   - Search filenames
#   grep dir    - Search directory names
#
# Ignore Pattern:
#   Uses glob matching, entried are wrapped with `**/.../**`
#   Ex: [ foo *bar* ]
#     - `foo` matches `**/foo/**` for exact files/dirs
#     - `*bar*` matches `**/*bar*/**` for substring match of files/dirs
#
# Use 'help grep <command>' for detailed help on each command
export def main [] {
  print "Grep utilities for recursive searching"
  print ""
  print "Available commands:"
  print "  grep all    - Search within file contents"
  print "  grep file   - Search filenames"
  print "  grep dir    - Search directory names"
  print ""
  print "Ignore Pattern:"
  print "  Uses glob matching, entried are wrapped with `**/.../**`"
  print "  Ex: [ foo *bar* ]"
  print "    - `foo` matches `**/foo/**` for exact files/dirs"
  print "    - `*bar*` matches `**/*bar*/**` for substring match of files/dirs"
  print ""
  print "Use 'help grep <command>' for detailed help on each command"
}

# Recursively search text file contents
export def all [
  ...pattern: string # Regex pattern
  --no-color (-n) # Disable colored output
  --enumerate (-e)  # Enumerate output
  --depth (-d): int = 999 # Directory depth to descend (1 is current)
  --ignore (-i): list<string> # Glob patterns to ignore in paths, entries are wrapped with `**/.../**`
]: nothing -> table<index: int, file: string, lineno: int, match: string> {
  let pattern = $pattern | str join " "
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
export def file [
  ...pattern: string # Regex pattern
  --no-color (-n) # Disable colored output
  --enumerate (-e)  # Enumerate output
  --depth (-d): int = 999 # Directory depth to descend (1 is current)
  --ignore (-i): list<string> # Patterns to ignore in paths
#     Glob pattern syntax:
#     - `*text*` matches foo/aatextbb/bar
#     - `text` matches foo/text/bar
]: nothing -> table<index: int, name: string, type: string, size: filesize, modified: datetime> {
  let pattern = $pattern | str join " "
  let ignore_pattern = ( $ignore | each { $"**/($in)/**" } ) | append $GREP_IGNORE
  glob **/* --exclude $ignore_pattern --depth $depth --no-dir --follow-symlinks
  | where { |path| ($path | path type) != symlink }
  | path relative-to (pwd)
  | where { |path| ($path | path basename) =~ $pattern }
  | par-each { |file|
    ls --mime-type $file
    | update type {mime $file}
    | if $no_color {$in} else {
        update name {str replace -ra "(.*/)" $"(ansi grey46)$1(ansi reset)"}
      }
    }
  | flatten
  | if $enumerate { enumerate | flatten } else {$in}
}


# Recursively search directory names
export def dir [
  ...pattern: string # Regex pattern
  --no-color (-n) # Disable colored output
  --enumerate (-e)  # Enumerate output
  --depth (-d): int = 999 # Directory depth to descend (1 is current)
  --ignore (-i): list<string> # Patterns to ignore in paths
#     Glob pattern syntax:
#     - `*text*` matches foo/aatextbb/bar
#     - `text` matches foo/text/bar
]: nothing -> table<index: int, name: string, size: filesize, modified: datetime> {
  let pattern = $pattern | str join " "
  let ignore_pattern = ( $ignore | each { $"**/($in)/**" } ) | append $GREP_IGNORE
  glob **/* --exclude $ignore_pattern --depth $depth --no-file --follow-symlinks
  | where { |path| ($path | path type) != symlink and $path != (pwd)  }
  | where { |path| ($path | path basename) =~ $pattern }
  | path relative-to (pwd)
  | par-each { |path|
      ls -D $path
      | update size (du $path | get physical | first)
    }
  | flatten
  | if $no_color {$in} else {
      update name {str replace -ra "(.*/)" $"(ansi grey46)$1(ansi reset)"}
    }
  | select name size modified
  | if $enumerate { enumerate | flatten } else {$in}
}
