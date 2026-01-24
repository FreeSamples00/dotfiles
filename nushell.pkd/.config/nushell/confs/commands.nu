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
alias gi = get-ignore

# __zoxide_z wrapper
def cd --env --wrapped [...args: directory] { __zoxide_z ...$args }

# Rename a file or directory
# Use the up arrow to edit the current filename
def rnm [
  path: path # Filepath to rename
]: nothing -> nothing {
  if ($path | path exists) {
    let path = $path | path expand
    let dir = $path | path dirname
    let new_path = [($path | path basename)] | input $"(ansi attr_bold)Rename File: (ansi reset)" --reedline
    if $new_path != "" {
      mv ($path) $"($dir)/($new_path)"
    }
  } else {
    print $"File `($path)` not found."
  }
}

# Use apple shortcut to open share options
def airdrop [
  file?: path # path to share target
] {
  if $file != null {
    shortcuts run airdrop-file -i $file
  } else {
    shortcuts run airdrop-file
  }
}

# Symlink Wrapper
def symlink [
  link: path # Location to create symlink
  file: path # Real file
] {
  ^ln -s ($file | path expand) $link
}
