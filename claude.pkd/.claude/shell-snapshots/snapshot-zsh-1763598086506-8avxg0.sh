# Snapshot file
# Unset all aliases to avoid conflicts with functions
unalias -a 2>/dev/null || true
# Functions
# Shell Options
setopt nohashdirs
setopt login
# Aliases
alias -- run-help=man
alias -- which-command=whence
# Check for rg availability
if ! command -v rg >/dev/null 2>&1; then
  alias rg='/opt/homebrew/Caskroom/claude-code/2.0.46/claude --ripgrep'
fi
export PATH='/Users/scc/dotfiles/scripts/in_path:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/pmk/env/global/bin:/Library/Apple/usr/bin:/Library/TeX/texbin:/Applications/Wireshark.app/Contents/MacOS:/Applications/VMware Fusion.app/Contents/Public:/usr/local/share/dotnet:~/.dotnet/tools:/Applications/quarto/bin:/Users/scc/.local/share/zinit/polaris/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/Applications/Sublime Text.app/Contents/SharedSupport/bin:/Users/sccmp/Library/Application Support/JetBrains/Toolbox/scripts:/Users/sccmp/.local/bin:/Users/scc/.local/bin:/Users/scc/.local/bin:/Applications/Ghostty.app/Contents/MacOS'
