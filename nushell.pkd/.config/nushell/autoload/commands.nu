# ----- Constants ----
const GREP_IGNORE = [ .git .venv __pycache__ .cache node_modules ]

# ----- Files -----

# Uses system `file` to check if a file is text
def is-text [
  filename?: string # File to check
]: [nothing -> bool, string -> bool] {
  let input = $in
  let file = $filename | default $input
  ^file -b --mime-type $file | str contains "text"
}

# ----- Git -----

# Get `git log` as structured data
def git-log-table [
  --limit (-n): int # Limit number of commits (optional)
]: nothing -> table<lots> {
  let log_args = if ($limit != null) { ["-n" $limit] } else { [] }

  git log ...$log_args --pretty=%s»¦«%h»¦«%aN»¦«%aE»¦«%at»¦«%D»¦«%cN»¦«%cE»¦«%ct»¦«%P
  | lines
  | split column "»¦«" subject hash author_name author_email author_timestamp refs committer_name committer_email committer_timestamp parents
  | upsert author_date {|d| ($d.author_timestamp | into int) * 1_000_000_000 | into datetime}
  | upsert committer_date {|d| ($d.committer_timestamp | into int) * 1_000_000_000 | into datetime}
  | sort-by author_date
  | reverse
}

# ----- Grepping -----

# Recursively search text file contents
def grepa [
  pattern: string # Regex pattern
  --no-color (-n) # Disable colored output
  --ignore (-i): list<string> # Patterns to ignore in paths
]: nothing -> table<index: int, file: string, lineno: int, match: string> {
  let ignore_pattern = $ignore | append $GREP_IGNORE | str join '|'
  ls -lat **/*
  | where type != dir
  | where not ($it.name =~ $ignore_pattern)
  | get name
  | par-each { |file|
    if (is-text $file) {
        open --raw $file
      | lines
      | enumerate
      | where { $in.item =~ $pattern }
      | if $no_color {
        each {{
          file: $file,
          line: ($in.index + 1),
          match: $in.item
          }}
        } else {
        each {{
          file: ($file | str replace -ra "(.*/)" $"(ansi grey46)$1(ansi reset)"),
          line: ($in.index + 1),
          match: ($in.item | str replace -ra $"\(($pattern)\)" $"(ansi red_bold)$1(ansi reset)")
          }}
        }
    } else {[]}
    | sort-by -n line
    }
  | flatten
  | enumerate
  | flatten
}


# Recursively search filenames
def grepf [
  pattern: string # Regex pattern
  --no-color (-n) # Disable colored output
  --ignore (-i): list<string> # Patterns to ignore in paths
]: nothing -> table<index: int, name: string, type: string, size: filesize, modified: datetime> {
  let ignore_pattern = $ignore | append $GREP_IGNORE | str join '|'
  ls -amt **/*
  | where type != dir
  | where not ($it.name =~ $ignore_pattern)
  | where ($it.name | path basename) =~ $pattern
  | each { |row| $row | update type { if (is-text $row.name) { "text" } else { $row.type } } }
  | if $no_color {$in} else {
      update name {str replace -ra "(.*/)" $"(ansi grey46)$1(ansi reset)"}
    }
  | sort-by name
  | enumerate
  | flatten
}

# Recursively search directory names
def grepd [
  pattern: string # Regex pattern
  --no-color (-n) # Disable colored output
  --ignore (-i): list<string> # Patterns to ignore in paths
]: nothing -> table<index: int, name: string, size: filesize, modified: datetime> {
  let ignore_pattern = $ignore | append $GREP_IGNORE | str join '|'
  ls -at **/*
  | where type == dir
  | where not ($it.name =~ $ignore_pattern)
  | where name =~ $pattern
  | select name size modified
  | sort-by name
  | if $no_color {$in} else {
      update name {str replace -ra "(.*/)" $"(ansi grey46)$1(ansi light_cyan)"}
    }
  | enumerate
  | flatten
}

# ----- ls -----
def ll []: nothing -> nothing {
  ls -lam
  | each { |row| $row | update type { if (is-text $row.name) { "text" } else { $row.type } } }
}
