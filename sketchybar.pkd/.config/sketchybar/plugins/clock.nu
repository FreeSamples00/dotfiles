#!/usr/bin/env nu -n

def main [
  animation_type: string
  animation_speed: string
  format: string
] {
  sketchybar ...[
    --animate $animation_type $animation_speed
    --set $env.name
    label=(date now | format date ($format))
  ]
}
