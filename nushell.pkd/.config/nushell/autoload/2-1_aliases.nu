# ----- Shell -----
alias reload = exec nu

# ----- Macos -----
alias sys-open = ^open

# ----- Clear -----
alias c = clear
alias cls = do { c; ls }

# ----- rm -----
alias rm = rm -I

# ----- Git -----
alias glt = git-log-table
alias gst = git status
alias gl = git pull
alias gp = git push
alias gf = git fetch
alias gc = git commit --verbose
alias gcm = git commit -m
alias gca = git commit --verbose --all
alias ga = git add
alias grmc = git rm --cached
alias gb = git branch
alias gbs = git switch
alias gco = git checkout
alias lg = lazygit

# ----- Torrent -----
alias torrent = transmission-cli

# ----- Pager -----
alias less = less -R

# ----- tree -----
alias tree = tree -aC -I .git -I .venv -I "._*"

# ----- Opencode -----
alias opencode = opencode --agent=plan
alias ai = opencode
