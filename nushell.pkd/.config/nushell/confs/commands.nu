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

# __zoxide_z wrapper
def cd --env --wrapped [...args: directory] { __zoxide_z ...$args }
