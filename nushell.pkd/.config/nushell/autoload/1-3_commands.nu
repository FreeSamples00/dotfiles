# ----- Constants ----
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

# ----- Env -----
def env-search [
  pattern: string # target
] {
  $env | transpose key value | find -ir $pattern
}

# ----- Files -----

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

# ----- Grepping -----

# Recursively search text file contents
def grepa [
  ...pattern: string # Regex pattern
  --no-color (-n) # Disable colored output
  --enumerate (-e)  # Enumerate output
  --depth (-d): int = 999 # Directory depth to descend (1 is current)
  --ignore (-i): list<string> # Patterns to ignore in paths (glob pattern, use `*text*` to match all paths containing `text`)
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
def grepf [
  ...pattern: string # Regex pattern
  --no-color (-n) # Disable colored output
  --enumerate (-e)  # Enumerate output
  --depth (-d): int = 999 # Directory depth to descend (1 is current)
  --ignore (-i): list<string> # Patterns to ignore in paths (glob pattern, use `*text*` to match all paths containing `text`)
]: nothing -> table<index: int, name: string, type: string, size: filesize, modified: datetime> {
  let pattern = $pattern | str join " "
  let ignore_pattern = ( $ignore | each { $"**/($in)/**" } ) | append $GREP_IGNORE
  glob **/* --exclude $ignore_pattern --depth $depth --no-dir --follow-symlinks
  | path relative-to (pwd)
  | where { |in| ($in | path basename) =~ $pattern }
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
def grepd [
  ...pattern: string # Regex pattern
  --no-color (-n) # Disable colored output
  --enumerate (-e)  # Enumerate output
  --depth (-d): int = 999 # Directory depth to descend (1 is current)
  --ignore (-i): list<string> # Patterns to ignore in paths
]: nothing -> table<index: int, name: string, size: filesize, modified: datetime> {
  let pattern = $pattern | str join " "
  let ignore_pattern = ( $ignore | each { $"**/($in)/**" } ) | append $GREP_IGNORE
  glob **/* --exclude $ignore_pattern --depth $depth --no-file --follow-symlinks
  | where { |in| $in != (pwd) }
  | where { |in| ($in | path basename) =~ $pattern }
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

# ----- git rev-parse -----

# Open gitignore
def ignore []: nothing -> nothing {
  let file = ".gitignore"
  if (git status | complete | get exit_code) == 0 {
    nvim $"(git rev-parse --show-toplevel)/($file)"
  } else {
    nvim ./($file)
  }
}

# Open Todo file
def todo []: nothing -> nothing {
  let file = "TODO.md"
  if (git status | complete | get exit_code) == 0 {
    nvim $"(git rev-parse --show-toplevel)/($file)"
  } else {
    nvim ./($file)
  }
}

# Open Readme file
def readme []: nothing -> nothing {
  let file = "README.md"
  if (git status | complete | get exit_code) == 0 {
    nvim $"(git rev-parse --show-toplevel)/($file)"
  } else {
    nvim ./($file)
  }
}

# ----- Git -----

# Get gitignore rules by language
@complete ignore-completer
def get-ignore [
  project_type? # Project type to get completions for
  --refresh (-r) # Refresh cache
] {
  let cache = "~/.cache/nushell/ignore-cache.json" | path expand
  if $refresh {
    rm -f $cache
    return
  }
  http get $"https://www.toptal.com/developers/gitignore/api/($project_type)"
}
