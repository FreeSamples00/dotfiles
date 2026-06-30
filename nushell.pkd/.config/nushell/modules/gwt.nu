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
    git branch --list | lines
    | where { |line| not ($line | str starts-with '+') }
    | each { |line|
        let name = ($line | str replace -r '^[\*\+]?\s+' '')
        { value: $name, description: $"branch ($name)" }
    }
}

# Parse git worktree list --porcelain into structured records
def parse-worktrees [] {
    git worktree list --porcelain
    | lines
    | split list ""
    | each { |group|
        $group
        | reduce -f {} { |line, acc|
            if ($line | str contains " ") {
                let parts = ($line | split row " " -n 2)
                $acc | upsert $parts.0 $parts.1
            } else if not ($line | is-empty) {
                $acc | upsert $line true
            } else {
                $acc
            }
        }
    }
    | where worktree? != null
}

def worktree-completer [] {
    parse-worktrees
    | where bare? != true and branch? != null
    | each { |rec|
        let name = ($rec.branch | str replace "refs/heads/" "")
        { value: $name, description: $"worktree ($name)" }
    }
}

# Look up filesystem path for a branch's worktree
def get-worktree-path [branch: string] {
    let records = (parse-worktrees)
    let match = ($records | where branch? == $"refs/heads/($branch)")
    if ($match | is-empty) {
        error make { msg: $"No worktree found for branch '($branch)'" }
    }
    $match.worktree.0
}

# Run .setup.sh in a worktree if it exists
def run-setup [wt_dir: string] {
    if ($"($wt_dir)/.setup.sh" | path exists) {
        print "  Running .setup.sh..."
        cd $wt_dir
        sh .setup.sh
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
  --dir (-d): string # override directory name (default: branch with / → -)
] {
  let dir = ($dir | default ($branch | str replace "/" "-"))
  git worktree add $dir -- $branch
  run-setup $dir
}

# Create new branch + worktree
export def new [
  branch: string # new branch name
  --base (-b): string@branch-completer = "main" # branch to base off of
] {
  let dir = ($branch | str replace "/" "-")
  git worktree add $dir $base -b $branch
  run-setup $dir
}

# Prune old references
export def prune [] {
  git worktree prune
}

# Remove a worktree
export def rm [
  branch: string@worktree-completer # branch to remove worktree from
  --force (-f) # delete branch as well (even if unmerged)
] {
  let path = (get-worktree-path $branch)
  git worktree remove $path
  if $force {
    git branch -D $branch
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
      let wt_dir = ($b | str replace "/" "-")
      git worktree add $wt_dir --checkout -- $b
      run-setup $wt_dir
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
    let records = (parse-worktrees)
    let bare = ($records | where bare? == true)
    let root = if ($bare | is-empty) {
        $records | get worktree | first
    } else {
        $bare | get worktree | first
    }
    let root = ($root | path expand | path dirname)
    $records
    | where bare? != true
    | each { |rec|
        let name = if ($rec | get -o detached) == true {
            "(detached HEAD)"
        } else {
            $rec.branch | str replace "refs/heads/" ""
        }
        let commit = ($rec | get -o HEAD | default "unknown")
        let short = ($commit | str substring 0..7)
        let full_path = ($rec.worktree | path expand)
        let path = ($full_path | path relative-to $root)
        let message = (git log --oneline -1 $commit | str replace -r '^[a-f0-9]+\s+' '')
        let locked = if ($rec | get -o locked) != null { " locked" } else { "" }
        let prunable = if ($rec | get -o prunable) != null { " prunable" } else { "" }
        {
            name: $"(ansi cyan_bold)($name)(ansi reset)($locked)($prunable)"
            commit: $"(ansi yellow)($short)(ansi reset)"
            path: $"(ansi blue_bold)($path)(ansi reset)"
            message: $"(ansi default)($message)(ansi reset)"
        }
    }
}

# Change directory to a worktree
export def --env switch [
  branch: string@worktree-completer # branch whose worktree to switch to
] {
  let path = (get-worktree-path $branch)
  cd $path
}
