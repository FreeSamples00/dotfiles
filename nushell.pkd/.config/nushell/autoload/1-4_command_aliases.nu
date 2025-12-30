# Nvim wrapper
def e [...args: path] { nvim ...$args }

# __zoxide_z wrapper
def cd --env --wrapped [...args: directory] { __zoxide_z ...$args }
