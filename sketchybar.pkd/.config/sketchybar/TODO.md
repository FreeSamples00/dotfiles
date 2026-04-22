# Sketchybar TODOs

## Features

### Docker

- [ ] docker item that only shows if docker is running
- [ ] shows number of containers running
- [ ] on click show more details

```nu
def dls () { docker images --format json | from json --objects } # get docker info
dls | get Containers | into int | math sum # num containers
```

### AI usage

- [ ] on click show more stats
  - [ ] reset time
  - [ ] specific numbers

### Status

- [ ] add a focus indicator
  - [ ] same hidden style as restart notifier
  - [ ] in same menu item as restart notifier

## Bugs

I think sketchybar is spawning aerospace processes for each state update that get orphaned, look into fixing that
