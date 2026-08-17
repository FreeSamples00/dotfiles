#!/usr/bin/env nu -n

def main [] {
  let script = [
    ($env.CONFIG_DIR)/plugins/ai-usage.nu
    $env.name
    $env.animation_type
    $env.animation_speed
  ] | str join " "
  use ../core/icons.nu *
  sketchybar ...[
    --add
    item
    $env.name
    $env.side
    --animate
    $env.animation_type
    $env.animation_speed
    --set
    $env.name
    icon.font=($env.icon_font)
    icon.color=($env.color)
    label.color=($env.color)
    script=($script)
    click_script=($script)
    icon=(icons widget "ai")
    label=--
    update_freq=($env.update_freq)
    --subscribe
    $env.name
    opencode-completion
  ]
}
