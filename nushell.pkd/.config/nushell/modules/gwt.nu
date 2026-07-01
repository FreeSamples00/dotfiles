# Git worktree helper
#
# Manage bare-repo worktrees: clone, add, switch, remove.
# Worktrees are linked to a shared .bare repo with a .shared config dir.

use std-rfc/pb

# ── Completers ──────────────────────────────────────────────────────────────

def connection-completer [] {
  [
    {value: "ssh", description: "Clone via SSH (requires SSH key)"}
    {value: "https", description: "Clone via HTTPS (public only)"}
    {value: "http", description: "Clone via HTTPS (public only)"}
  ]
}

def branch-completer [] {
  git branch --list
  | lines
  | each { |line|
        let name = $line | str replace -r '^[\*\+]?\s+' ''
        { value: $name, description: $"branch ($name)" }
    }
}

def new-branch-completer [] {
  git branch --list
  | lines
  | where {|line| not ($line | str starts-with '+') }
  | each { |line|
        let name = $line | str replace -r '^[\*\+]?\s+' ''
        { value: $name, description: $"branch ($name)" }
    }
}

def worktree-completer [] {
  parse-worktrees
  | where bare? != true and branch? != null
  | each { |rec|
        let name = $rec.branch | str replace "refs/heads/" ""
        { value: $name, description: $"worktree ($name)" }
    }
}

# ── Internal utilities ──────────────────────────────────────────────────────

# Parse `git worktree list --porcelain` into structured records
def parse-worktrees [] {
  git worktree list --porcelain
  | lines
  | split list ""
  | each { |group|
        $group
        | reduce -f {} { |line, acc|
            if ($line | str contains " ") {
                let parts = $line | split row " " -n 2
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

# Find the repo root from any worktree.
# git-common-dir points to .bare; its parent is the repo root.
def get-repo-root [] {
  git rev-parse --git-common-dir
  | path expand
  | path dirname
}

# Look up filesystem path for a branch's worktree
def get-worktree-path [branch: string] {
  let records = (parse-worktrees)
  let match = $records | where branch? == $"refs/heads/($branch)"
  if ($match | is-empty) {
    error make {msg: $"No worktree found for branch '($branch)'"}
  }
  $match.worktree.0
}

# Add worktree with standard directory naming and setup.
# Creates the worktree, links .shared, and runs .setup.sh if present.
#
# --base:  create a new branch off the given ref before adding the worktree
# --dir:   override the directory name (default: branch with / → -)
def add-worktree [
  branch: string        # branch name
  --dir (-d): string    # override directory name (default: branch with / → -)
  --base (-b): string   # base ref for creating a new branch (omit to checkout existing)
] {
  let dir = $dir | default ($branch | str replace "/" "-")
  let root = get-repo-root
  let worktree_path = [$root $dir] | path join

  # Create the worktree (new branch from base, or checkout existing)
  if $base != null {
    git worktree add $worktree_path $base -b $branch
  } else {
    git worktree add $worktree_path -- $branch
  }

  # Link shared config dir and exclude it from git
  cd $worktree_path
  ln -s ../.shared .shared

  # Run project setup script if present
  if ("./.setup.sh" | path exists) {
    print "  Running .setup.sh..."
    sh .setup.sh
  }
}

# ── Public commands ─────────────────────────────────────────────────────────

# Show available commands
export def main [] {
  scope commands
  | where name starts-with "gwt " and name != "gwt main"
  | update name { $in | str replace "gwt " "" }
  | select name description
  | rename command description
  | table -e
}

# Fetch from origin
export def fetch [] {
  git fetch origin
}

# Create worktree from existing branch
export def add [
  branch: string@new-branch-completer # branch to create worktree for
  --dir (-d): string                   # override directory name (default: branch with / → -)
] {
  add-worktree $branch --dir $dir
}

# Create new branch + worktree
export def new [
  branch: string                       # new branch name
  --base (-b): string@branch-completer = "main" # branch to base off of
  --dir (-d): string                   # override directory name (default: branch with / → -)
] {
  add-worktree $branch --base $base --dir $dir
}

# Prune stale worktree references
export def prune [] {
  git worktree prune
}

# Remove a worktree (and optionally its branch)
export def rm [
  branch: string@worktree-completer # branch whose worktree to remove
  --force (-f)                       # also delete the branch (even if unmerged)
] {
  let path = (get-worktree-path $branch)
  git worktree remove $path

  if $force {
    git branch -D $branch
  }

  git worktree prune
}

# Create a bare worktree repo from a remote.
# Uses `git init --bare` + single fetch to minimize hardware-token auth touches.
export def clone [
  owner:string                              # user or org
  repo:string                               # repo name
  --connection (-c):string@connection-completer = "ssh" # connection type
  --forge (-f):string@["github.com", "gitlab.com"] = "github.com" # git host
  --main (-m):string = "main"              # name of main branch
  --branch (-b):list<string>               # additional branches to add as worktrees
  --dir (-d):string                        # override directory name (default: repo name)
] {
  try {
    # Resolve remote URI
    pb set 0
    let scheme_domain = match $connection {
      ssh => $"git@($forge):"
      http => $"http://($forge)/"
      https => $"https://($forge)/"
      _ => (error make {msg: "invalid connection type"})
    }
    let link = $"($scheme_domain)($owner)/($repo)"

    # Initialize repo directory
    pb set 25
    print $"Initializing ($repo)..."
    let dir = $dir | default $repo
    if ($dir | path exists) { error make $"directory '($dir)' already exists" }
    mkdir $dir
    cd $dir
    git init --bare .bare
    "gitdir: ./.bare" | save .git

    # Configure remote refspecs before the single fetch
    git remote add origin $link
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git config --add remote.origin.fetch "+refs/tags/*:refs/tags/*"

    # Fetch all refs in a single auth touch
    pb indeterminate
    print "Fetching from origin..."
    git fetch origin

    # Create shared config dir and grow worktrees
    pb set 75
    mkdir "./.shared"
    ".shared" | save --append "./.bare/info/exclude"

    $branch | append $main | uniq | each {|b|
      print $"Adding ($b)..."
      add-worktree $b
    }

    pb set 100
  } catch {|err|
    pb error
    sleep 0.5sec
    error make $err
  } finally {
    pb clear
  }
}

# List worktrees with branch, commit, and path info
export def ls [] {
  let records = (parse-worktrees)
  let root = get-repo-root

  # Format each non-bare worktree
  $records
  | where bare? != true
  | each { |rec|
        let name = if ($rec | get -o detached) == true {
            "(detached HEAD)"
        } else {
            $rec.branch | str replace "refs/heads/" ""
        }
        let commit = $rec | get -o HEAD | default "unknown"
        let short = $commit | str substring 0..7
        let full_path = $rec.worktree | path expand
        let path = $full_path | path relative-to $root
        let message = git log --oneline -1 $commit | str replace -r '^[a-f0-9]+\s+' ''
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
