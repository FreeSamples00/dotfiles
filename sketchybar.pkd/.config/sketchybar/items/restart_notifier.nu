#!/usr/bin/env nu -n

def main [] {
  use ../core/icons.nu *
  let script = [
    ($env.CONFIG_DIR)/plugins/restart_notifier.nu
    $env.animation_type
    $env.animation_speed
    $env.threshold
  ] | str join " "
  sketchybar ...[
    --add item $env.name $env.side
    --set $env.name
    icon=(icons "widget" "restart")
    icon.color=($env.color)
    label.padding_right=0
    label.padding_left=0
    script=($script)
    click_script=`osascript -e 'tell application "loginwindow" to «event aevtrrst»'`
    update_freq=($env.update_freq)
    drawing=off
  ]
}
