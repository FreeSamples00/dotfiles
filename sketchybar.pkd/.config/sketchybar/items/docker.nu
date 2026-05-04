#!/usr/bin/env nu -n

def main [] {
  use ../core/icons.nu *
  let script = [
    ($env.CONFIG_DIR)/plugins/docker.nu
    $env.name
    $env.animation_type
    $env.animation_speed
  ] | str join " "
  sketchybar ...[
    --add
    item
    $env.name
    $env.side
    --set
    $env.name
    icon=(icons widget docker)
    icon.font=($env.icon_font)
    icon.color=($env.color)
    label.color=($env.color)
    label.padding_left=0
    script=($script)
    click_script=($script)
    update_freq=($env.update_freq)
    drawing=off
    --subscribe
    $env.name
    system_woke
  ]
}
