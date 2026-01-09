export alias glt = git-log-table
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
] {
  if $con_type == ssh {
    git clone $"git@github.com:($target)" ...$args
  } else if $con_type == https {
    with-env { GIT_TERMINAL_PROMPT: "0" } {
      git clone $"https://github.com/($target)" ...$args
    }
  } else {
    error make {
      msg: $"Connection type `($con_type)` not supported."
      help: $"Use one of: (gcl-con-completer | get value)"
      label: {
        text: "unknown type"
        span: (metadata $con_type | get span)
      }
    }
  }
}
