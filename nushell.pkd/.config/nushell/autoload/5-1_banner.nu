clear
sleep (500ms - $nu.startup-time | math abs)
sys host | get hostname | split row '.' | get 0
| if not (which figlet | is-empty) {^figlet -c -w $"(term size | get columns)"} else {$in}
| if not (which lolcat | is-empty) {^lolcat -f} else {$in}
| print
print ""
print $"(ansi grey)Startup Time: ($nu.startup-time)(ansi reset)"
