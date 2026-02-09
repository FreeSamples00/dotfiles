#!/usr/bin/env nu -n

# Transparency codes
# 100%:  0xFF
# 75%: 0xBF
# 50%: 0x80
# 25%: 0x40

def to_sec [
  time: duration
] {
  ($time | into int) / 1_000_000_000 | into int
}

const theme = {
  name: "catppuccin-mocha"
  colors: {
    transparent: "0x00ffffff"
    light_gray: "0xFFa6adc8"
    white: "0xFFcdd6f4"
    red: "0xFFf38ba8"
    yellow: "0xFFf9e2af"
    blue: "0xFF89b4fa"
    green: "0xFFa6e3a1"
    magenta: "0xFFf5c2e7"
    cyan: "0xFF89dceb"
    orange: "0xFFfab387"
    tangerine: "0xFFeba0ac"
    purple: "0xFF8b6baf"
    black: "0xFF171723"
    black_75: "0xBF171723"
  }
}

# TODO: define standard sizes?
const fonts = {
  icon: {
    family: "SpaceMono Nerd Font Mono"
    style: Bold
    size: 20
  }
  label: {
    family: "JetBrainsMono Nerd Font Mono"
    style: Bold
    size: 17
  }
  ske_app: {
    family: sketchybar-app-font
    style: Regular
    size: 14
  }
}

const defaults = {
  bar: {
    height: 56
    y_offset: -10
    position: top
    color: transparent
  }
  bracket: {
    height: 28
    color: $"($theme.colors.black_75)"
    corner_radius: 4
    border_width: 1
  }
  label: {
    font: $fonts.label
    padding: {
      left: 0
      right: 8
    }
    color: transparent
  }
  icon: {
    font: $fonts.icon
    padding: {
      left: 8
      right: 6
    }
    color: transparent
  }
}

export const skenv =  {
  theme: $theme.name
  defaults: $defaults
  spacer: {
    width: 8
    # color: $"($theme.colors.red)" # TODO:
    color: "transparent"
  }
  widgets: {
    # NOTE: ===== left side items, ordered out to in =====
    apple: {
      enable: true
      name: apple
      color: $"($theme.colors.red)"
      side: left
    }
    aerospace: {
      enable: true
      name: aerospace
      color_focused: $"($theme.colors.orange)"
      color_full: $"($theme.colors.magenta)"
      color_empty: $"($theme.colors.light_gray)"
      label_pad: 4
      outer_pad: 4
      update_freq: 5
      side: left
    }
    focused_app: {
      enable: true
      name: focused_app
      color: $"($theme.colors.green)"
      side: left
      icon_font: $"($fonts.ske_app.family):($fonts.ske_app.style):($fonts.ske_app.size)"
    }
    restart_notifier: {
      enable: true
      name: restart_notifier
      color: $"($theme.colors.red)"
      threshold: "7day" # needs to be string for env passing
      update_freq: 3600 # hour in seconds
      side: left
    }
    # NOTE: ===== right side items, ordered out to in =====
    clock: {
      enable: true
      name: clock
      format: "%-m/%d %-l:%M" # reference with `format date -l`
      color: $"($theme.colors.yellow)"
      update_freq: 1
      side: right
    }
    volume: {
      enable: true
      name: volume
      color: $"($theme.colors.blue)"
      icon_font: $"($fonts.icon.family):($fonts.icon.style):($fonts.icon.size + 4)"
      right_pad: $defaults.label.padding.right
      side: right
    }
    battery: {
      enable: true
      name: battery
      color: $"($theme.colors.orange)"
      side: right
      icon_font: $"($fonts.icon.family):($fonts.icon.style):($fonts.icon.size + 4)"
      update_freq: 5
    }
    weather: { # TODO:
      enable: false
      name: weather
      color: $"($theme.colors.cyan)"
      location: Milwaukee
      temp_unit: F
      side: right
    }
    mail: { # TODO:
      enable: false
      name: mail
      color: $"($theme.colors.blue)"
      side: right
    }
    caffeinate: { # TODO:
      enable: false
      name: caffeinate
      color: $"($theme.colors.green)"
      side: right
    }
  }
  animation: {
    type: exp
    speed: 15
  }
  custom_events: [
    aerospace_workspace_change
  ]
}
