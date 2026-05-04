#!/usr/bin/env nu -n

def get_focus [] {
  use ../core/icons.nu *
  return (match (^($env.FILE_PWD | path join "getfocus")) {
    "Do Not Disturb" => {
      {
        icon: (icons widget "focus_dnd")
        color: "0xFF6D7CFF", 
        draw: "on"
      }
    }
    "Sleep" => {
      {
        icon: (icons widget "focus_sleep")
        color: "0xFF14B6A4"
        draw: "on"
      }
    }
    "Reduce Interruptions" => {
      {
        icon: (icons widget "focus_reduce")
        color: "0xFFDB34F2"
        draw: "on"
      }
    }
    _ => {
      {
        icon: "", 
        color: "0xFF6D7CFF", 
        draw: "off"
      }
    }
  })
}

def main [name: string, animation_type: string, animation_speed: string] {
  let focus = get_focus
  sketchybar ...[
    --animate
    $animation_type
    $animation_speed
    --set
    $name
    icon=($focus.icon)
    icon.color=($focus.color)
    drawing=($focus.draw)
  ]
}
