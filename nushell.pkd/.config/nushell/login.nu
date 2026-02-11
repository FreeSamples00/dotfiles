$env.config.show_banner = 'short'

sys host | get hostname | str replace -r "\\..*" ""
| if not (which figlet | is-empty) {^figlet -f rectangles -l} else {$in}
| if not (which lolcat | is-empty) {^lolcat -f} else {$in}
