# Git worktree helper

use std-rfc/pb

def connection-completer [] {
  [
    {value: "ssh", description: "Clone via SSH (requires SSH key)"}
    {value: "https", description: "Clone via HTTPS (public only)"}
    {value: "http", description: "Clone via HTTPS (public only)"}
  ]
}

def branch-completer [] {
    git branch --list | lines | each { |line|
        let name = ($line | str replace -r '^[\*\+]?\s+' '')
        { value: $name, description: $"branch ($name)" }
    }
}

def new-branch-completer [] {
    git branch --list | lines
    | where { |line| not ($line | str starts-with '+') }
    | each { |line|
        let name = ($line | str replace -r '^\*?\s+' '')
        { value: $name, description: $"branch ($name)" }
    }
}

# Git worktree helper
export def main [] {
  scope commands
  | where name starts-with "gwt " and name != "gwt main"
  | update name { $in | str replace "gwt " "" }
  | select name description
  | rename command description
  | table -e
}

# Fetch remote
export def fetch [] {
  git fetch origin
}

# Create worktree from existing branch
export def add [
  branch: string@new-branch-completer # branch to create worktree for
] {
  git worktree add ($branch | str replace "/" "-") -- $branch
}

# Create new branch + worktree
export def new [
  branch: string # new branch name
  --base (-b): string@branch-completer = "main" # branch to base off of
] {
  git worktree add ($branch | str replace "/" "-") $base -b $branch
}

# Prune old references
export def prune [] {
  git worktree prune
}

# Remove a worktree
export def rm [
  branch: string@branch-completer # branch to remove worktree from
  --delete (-d) # delete branch aswell
] {
  git worktree remove ($branch | str replace "/" "-")
  if $delete {
    git branch -d $branch
  }
  git worktree prune
}

# Create worktree repo via clone
export def clone [
  owner:string # user or org
  repo:string # repo name
  --connection (-c):string@connection-completer = "ssh" # connection type
  --forge (-f):string@["github.com", "gitlab.com"] = "github.com" # git host
  --main (-m):string = "main" # name of 'main' branch
  --branch (-b):list<string> # branches (as list)
  --dir (-d):string # name of dir to clone into
] {
  try {
# create full URI
    pb set 0
    let scheme_domain = match $connection {
      "ssh" => $"git@($forge):"
      "http" => $"http://($forge)/"
      "https" => $"https://($forge)/"
      _ => (error make {msg: "invalid connection type"})
    }
    let link = $"($scheme_domain)($owner)/($repo)"
# create new dir
    pb set 25
    let dir = $dir | default $repo
    if ($dir | path exists) {error make $"directory '($dir)' already exists"}
    mkdir $dir
    cd $dir
# clone operation
    pb indeterminate
    print "Cloning..."
    git clone --bare $link .bare
# configuring
    pb set 50
    "gitdir: ./.bare" | save .git
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
# fetching
    pb indeterminate
    print "Fetching..."
    git fetch origin
# growing trees
  $branch | append $main | uniq | each {|b|
    print $"Adding ($b)..."
    add $b
  }
  } catch {|err|
    pb error
    sleep 0.5sec
    error make $err
  } finally {
    pb clear
  }
}

# List worktrees
export def ls [] {
    let lines = (git worktree list | lines)
    let root = (
        $lines
        | where { |line| $line | str contains "(bare)" }
        | first
        | str replace -r '\s+\(bare\)\s*$' ''
        | path expand
        | path dirname
    )
    $lines
    | where { |line| not ($line | str contains "(bare)") }
    | each { |line|
        let name = ($line | str replace -r '^.*\[(.+)\]$' '$1')
        let commit = ($line | str replace -r '^.*\s([a-f0-9]+)\s+\[.+\]$' '$1')
        let full_path = ($line | str replace -r '\s+[a-f0-9]+\s+\[.+\]$' '' | path expand)
        let path = ($full_path | path relative-to $root)
        let message = (git log --oneline -1 $commit | str replace -r '^[a-f0-9]+\s+' '')
        {
            name: $"(ansi cyan_bold)($name)(ansi reset)"
            commit: $"(ansi yellow)($commit)(ansi reset)"
            path: $"(ansi blue_bold)($path)(ansi reset)"
            message: $"(ansi default)($message)(ansi reset)"
        }
    }
}
