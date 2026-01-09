# reload shell
alias reload = exec nu

# Nvim wrapper
def e --env --wrapped [...args: path] { nvim ...$args }

# __zoxide_z wrapper
def cd --env --wrapped [...args: directory] { __zoxide_z ...$args }
