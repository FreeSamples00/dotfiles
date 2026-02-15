# Module for git aliases and helpful scripts

# USAGE: import with `use /path/to/git.nu *`

export alias gst = git status
export alias gl = git pull
export alias gp = git push
export alias gf = git fetch
export alias gc = git commit --verbose
export alias gcm = git commit -m
export alias gca = git commit --verbose --all
export alias ga = git add
export alias grmc = git rm --cached
export alias gb = git branch
export alias gbs = git switch
export alias gco = git checkout
export alias lg = lazygit

def gcl-con-completer [] {
  [
    { value: "ssh", description: "Clone via SSH (requires SSH key)" }
    { value: "https", description: "Clone via HTTPS (public only)" }
    { value: "http", description: "Clone via HTTPS (public only)" }
  ]
}

# Clone from github
#
# Usage:
#   `gcl username/repository`           # Clone repo
#   `gcl -t https username/repository`  # Clone repo over https
export def gcl [
  target: string # username/repository
  ...args: string # git clone args
  --con-type (-t): string@gcl-con-completer = "ssh" # Connection type
  --branch (-b): string # Branch name
  --depth (-d): int # Depth to clone history at
] {

  let URL = match $con_type {
    "ssh" => "git@github.com:"
    "http" => "https://github.com/"
    "https" => "https://github.com/"
    _ => (error make {
        msg: $"Connection type `($con_type)` not supported."
        help: $"Use one of: (gcl-con-completer | get value)"
        label: {
          text: "unknown type"
          span: (metadata $con_type | get span)
        }
      }
    )
  }

  let args = if $branch != null { ($args | append $"--branch=($branch)") } else {$args}
  let args = if $depth != null { ($args | append $"--depth=($depth)") } else {$args}

  let env_vars = if $con_type == https { { GIT_TERMINAL_PROMPT: "0" } } else { {} }

  with-env $env_vars {
    git clone $"($URL)($target)" ...$args
  }
}
