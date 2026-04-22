#!/usr/bin/env nu -n

def workspace_status [
  workspace: string
] {
  let focused = ^aerospace list-workspaces --focused | complete | get stdout | str trim
  if $workspace == $focused {
    return "active"
  } else {
    let windows = ^aerospace list-windows --workspace $workspace | complete | get stdout | lines | length
    if $windows > 0 {
      return "full"
    } else {
      return "empty"
    }
  }
}

def main [
  name: string
  workspace: string
  active_color: string
  full_color: string
  empty_color: string
] {
  let color = match (workspace_status $workspace)  {
    active => $active_color
    full => $full_color
    empty => $empty_color
    _ => "#000000"
  }
  sketchybar ...[
    --set $name
    label.color=($color)
  ]
}
