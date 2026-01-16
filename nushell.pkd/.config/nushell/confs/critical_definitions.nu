# Commands that should be loaded first so they are present even if configurations crash

# Reload shell configuration
def reload [
  --login (-l) # Reload as login shell
]: nothing -> nothing {
  if $login {
    exec nu -l
  } else {
    exec nu
  }
}

# Nvim wrapper
def e --env --wrapped [...args: path] { nvim ...$args }

# shorter clear
alias c = clear

# clear + ls
alias cls = do { clear; print ""; ls }
