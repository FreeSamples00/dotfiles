_default:
    @just --unsorted --list

# Check Lua formatting with stylua
check:
    stylua --check .
alias c := check

# Format Lua files with stylua
format:
    stylua .
alias f := format
alias fmt := format
