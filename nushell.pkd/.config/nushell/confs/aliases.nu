# ---- system ----

# Open pwd in finder
alias ofd = ^open -R (pwd)

# ----- Clear -----

alias c = clear
alias cls = do { clear; print ""; ls }

# ----- Built-ins -----

alias rm = rm -I
alias explore = explore -pi

# ----- Torrent -----

alias torrent = transmission-cli

# ----- Pager -----

alias less = less -R

# ----- tree -----

alias tree = tree -aC -I .git -I .venv -I "._*"

# ----- Opencode -----

# opencode in plan mode
alias ai = opencode --agent=plan
