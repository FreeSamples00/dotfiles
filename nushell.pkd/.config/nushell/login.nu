# figlet options
let flet = {
  style: "rectangles"
  flush: -l
}

# lolcat options
mut lcat = {
  speed: 20  # frames per second
  duration: "1" # frames per line
  animate: true # toggle animation
}

$lcat = ($lcat | update animate { |opt| if $opt.animate {-a} else {[]}})

$env.config.show_banner = 'short'

sys host | get hostname | str replace -r "\\..*" ""
| if not (which figlet | is-empty) {^figlet -f ($flet.style) ($flet.flush)} else {$in}
| if not (which lolcat | is-empty) {^lolcat -f -t ($lcat.animate) -s ($lcat.speed) -d ($lcat.duration) } else {$in}
| print
