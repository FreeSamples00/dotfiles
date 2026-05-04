#!/usr/bin/env nu -n

def main [] {
  use ../core/icons.nu *
  let script = [
    ($env.CONFIG_DIR)/plugins/focus_notifier.nu
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
    label.padding_right=0
    label.padding_left=0
    script=($script)
    click_script=($script)
    update_freq=($env.update_freq)
    drawing=on
    --subscribe
    $env.name
    system_woke
  ]
}
