#!/usr/bin/env nu -n

let bar_defaults = $skenv.defaults.bar
let icon_defaults = $skenv.defaults.icon
let label_defaults = $skenv.defaults.label

sketchybar ...[
  --default
  icon.font=($icon_defaults.font.family):($icon_defaults.font.style):($icon_defaults.font.size)
  icon.color=($icon_defaults.color)
  icon.padding_left=($icon_defaults.padding.left)
  icon.padding_right=($icon_defaults.padding.right)
  label.font=($label_defaults.font.family):($label_defaults.font.style):($label_defaults.font.size)
  label.color=($label_defaults.color)
  label.padding_left=($label_defaults.padding.left)
  label.padding_right=($label_defaults.padding.right)
  updates=when_shown
  --bar
  position=($bar_defaults.position)
  height=($bar_defaults.height)
  y_offset=($bar_defaults.y_offset)
  color=($bar_defaults.color)
]

$skenv.custom_events | each {|event|
  sketchybar --add event $event
}
