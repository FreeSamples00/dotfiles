# brew setup
if [[ -f "/opt/homebrew/bin/brew" ]] then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  ERROR_STATUS="$ERROR_STATUS\n\tHomeBrew path ''/opt/homebrew/bin/brew' not found (line ${LINENO})"
fi

# OS specific shorthands
alias copy='pbcopy'
alias paste='pbpaste'
alias ofd='open -R "$(pwd)"'
alias battery='system_profiler SPPowerDataType | grep -E "Cycle Count|Condition|Maximum Capacity" | cat'
