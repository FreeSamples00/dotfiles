clear
sleep 450ms # sleep to allow for window management before banner
sys host | get hostname | split row '.' | get 0
| if not (which figlet | is-empty) {^figlet -c -w $"(term size | get columns)"} else {$in}
| if not (which lolcat | is-empty) {^lolcat -f} else {$in}
| print
print ""
