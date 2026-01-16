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

# Convert markdown to pdf
alias 2pdf = mdpdf --ghstyle=true --border 0.5in

# unfreeze job 1
alias fg = job unfreeze (job list | reverse | where type == frozen | first | (if $in == null {null} else {$in.id}))
