# Reload shell configuration
def reload [
  --login (-l) # Reload as login shell
]: nothing -> nothing {
  if $login {
    clear; exec nu -l
  } else {
    exec nu
  }
}

# Mime the type of a file
def mime [
  file: path # File to mime the type of
  --full (-f) # Show full mimed type (**/** vs **)
]: nothing -> string {
  ^file --mime-type -b $file | str trim
  | if $in =~ "cannot open" {
    return "ERR"
  } else {$in}
  | if $full { $in
  } else {$in
    match $in {
      "application/octet-stream" => "binary"
      "text/plain" => "text"
      "inode/x-empty" => "empty"
      "inode/directory" => "dir"
      $other => (
        try {
          ($other | split row '/' | get 1 | str trim)
        } catch {$other}
      )
    }
  }
}

# __zoxide_z wrapper
def cd --env --wrapped [...args: directory] { __zoxide_z ...$args }

# Rename a file or directory
# Use the up arrow to edit the current filename
def rnm [
  path: path # Filepath to rename
]: nothing -> nothing {
  if not ($path | path exists) {
    return (error make {msg: $"Path ($path) does not exist"})
  }
  let path = $path | path expand
  let dir = $path | path dirname
  let new_path = [($path | path basename)] | input $"(ansi attr_bold)Rename File: (ansi reset)" --reedline
  if $new_path != "" {
    mv ($path) $"($dir)/($new_path)"
  }
}

# Manage file backups (.bak)
def bak [
  file: path      # File to modify
  --reverse (-r)  # remove .bak from file
  --force (-f)    # overwrite if new path exists
  --keep (-k)     # copy instead of move
]: nothing -> nothing {
  if not ($file | path exists) {
    return (error make $"Path ($file) does not exist")
  }

  let target = if $reverse {
    if not ($file | str contains ".bak") {
      return (error make $"File '($file)' not a backup")
    }
    $file | str replace -r "\\.bak$" ""
  } else {
    $"($file).bak"
  }

  if ($target | path exists) and (not $force) {
    return (error make $"New path '($target)' already exists, Use -f")
  }

  if $keep {
    cp -r $file $target
    print $"($file) => ($target)"
  } else {
    mv $file $target
    print $"($file) -> ($target)"
  }
}

# Symlink Wrapper
def symlink [
  link: path  # Location to create symlink
  file: path  # Real file
  --full (-f) # link to path from root
] {
  # force relative links
  let link = $link | str replace --regex "/$" ""
  let file = $file | str replace --regex "/$" "" | if ($full) {$in | path expand} else {$in}
  ^ln -s $file $link
}

# Send xterm-ghostty to remote machine
def ghostty-xterm [
  server: string # ssh config or user@server
] {
  infocmp -x xterm-ghostty | ssh $server -- tic -x -
}
