# open pwd in finder
alias ofd = ^open -R (pwd)

# copy pwd
alias cwd = do {use std/clip; pwd | clip copy}

# rm w/ interactive protection
alias rm = rm -I

# explore with sane default flags
alias explore = explore -pi

# torrent client
alias torrent = transmission-cli

# modify less args
alias less = less -R

# tree w/ args
alias tree = tree -aC -I .git -I .venv -I "._*"

# opencode in plan mode
alias ai = opencode --agent=plan

# Convert markdown to pdf
# alias 2pdf = mdpdf --ghstyle=true --border 0.5in
alias 2pdf = ^open -a helium

# unfreeze job 1
alias fg = job unfreeze (job list | reverse | where type == frozen | first | (if $in == null {null} else {$in.id}))

# customized tty-clock
alias clock = tty-clock -Bbsctn -C 5 -f "%A %m/%d %Y"

# shorter clear
alias c = clear

# Nvim wrapper
def e --env --wrapped [...args: path] {
  if (which nvim | is-empty) {
    vim ...$args
  } else {
    nvim ...$args
  }
}

# Wrapper for clear + ls
def cls [
  --long (-l) # detailed ls
] {
  clear; print ""; if $long {ls -l} else {ls}
}

# Usage:
#   `rsync <SRC> <DEST>`
#
# Flags:
#   `-a` archive: recursive, preserves file attributes
#   `-z` compression
#   `--stats` post transfer summary
alias rsync = rsync -az --stats
