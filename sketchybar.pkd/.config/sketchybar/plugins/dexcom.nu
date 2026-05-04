#!/usr/bin/env nu -n

use ~/.config/nushell/modules/dexcom.nu

def main [name: string, animation_type: string, animation_speed: string] {
  let result = try {
    let data = dexcom | first
    $"($data.Value) ($data.Arrow)"
  } catch {|err| "ERR" }

  sketchybar ...[
    --animate
    $animation_type
    $animation_speed
    --set
    $name
    label=($result)
  ]
}
