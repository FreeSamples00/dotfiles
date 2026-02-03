#!/usr/bin/env nu -n

def workspace_status [
  workspace: string
] {
  if $workspace == (^aerospace list-workspaces --focused) {
    return "active"
  } else {
    if (aerospace list-windows --workspace $workspace | lines | length) > 0 {
      return "full"
    } else {
      return "empty"
    }
  }
}

def main [
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
    --set $env.name
    label.color=($color)
  ]
}
