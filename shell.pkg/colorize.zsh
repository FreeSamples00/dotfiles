# ==================== COLORIZE MAN & HELP PAGES ==================== 

export LESS_TERMCAP_mb=$'\e[1;36m' # start blinking (bold cyan)
export LESS_TERMCAP_md=$'\e[1;33m' # start bold (bold yellow)
export LESS_TERMCAP_me=$'\e[0m'    # end attributes
export LESS_TERMCAP_so=$'\e[1;44;33m' # start standout (bold yellow on blue) - for headings/sections
export LESS_TERMCAP_se=$'\e[0m'    # end standout
export LESS_TERMCAP_us=$'\e[1;32m' # start underline (bold green) - for paths/filenames
export LESS_TERMCAP_ue=$'\e[0m'    # end underline
export LESS_TERMCAP_mh=$'\e[0m'    # disable half-bright
export LESS_TERMCAP_mr=$'\e[7m'    # enter reverse mode
export LESS_TERMCAP_ZJ=$'\e[1;35m' # bold magenta for comments (this one is less common, customize as needed)
export LESS_TERMCAP_ZN=$'\e[0m'    # end ZJ


alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

