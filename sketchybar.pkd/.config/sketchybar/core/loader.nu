#!/usr/bin/env nu -n

const bracket_defaults = $skenv.defaults.bracket

def add_spacer [
  name: string # Name of spacer
  side: string@[left center right] # Side of spacer
] {
  let name = $"spacer_($name)"
  sketchybar ...[
    --add item $name $side
    --set $name width=($skenv.spacer.width) background.color=($skenv.spacer.color)
    label.padding_right=0
    label.padding_left=0
    icon.padding_right=0
    icon.padding_left=0
  ]
}

def add_bracket [
  name: string # name of widget to wrap w/ bracket
] {
  let bname = $"($name)_bracket"
  sketchybar ...[
    --animate ($skenv.animation.type) ($skenv.animation.speed)
    --add bracket $bname $"/($name).*/"
    --set $bname
    background.color=($bracket_defaults.color)
    background.corner_radius=($bracket_defaults.corner_radius)
    background.height=($bracket_defaults.height)
    background.border_width=($bracket_defaults.border_width)
    background.drawing=on
  ]
}

export def load_widgets [
  widgets: record
] {
  $widgets | values
  | each {|widget|
      if $widget.enable {
      with-env ($widget | merge { animation_speed: $skenv.animation.speed animation_type: $skenv.animation.type}) {
        ./items/($widget.name).nu
      }
      add_bracket $widget.name
      add_spacer $widget.name $widget.side
    }
  }
}
