# Sketchybar Configuration

A modular, Nushell-based sketchybar configuration with automatic bracket wrapping, theme integration, and a clean item/plugin architecture.

## Requirements

- [sketchybar](https://github.com/FelixKratz/SketchyBar)
- [Nushell](https://www.nushell.sh/)
- [aerospace](https://github.com/nikitabobko/AeroSpace) (window manager) for workspace widgets
- Fonts:
  - SpaceMono Nerd Font Mono
  - JetBrainsMono Nerd Font Mono
- Optional:
  - Docker Desktop
  - Ghostty terminal
  - tty-clock

## Quick Start

Run `just` to see all available commands for interacting with sketchybar (reload, toggle, restart, etc.).

## Debugging

Adding `print $"Item: foo=($bar)"` debugging statements will log them when running in test mode.

Use `just test-auto` to run with a time-out and receive errors/logs.

## Directory Structure

```
.config/sketchybar/
├── sketchybarrc       # Entry point - loads config, defaults, and widgets
├── config.nu          # Central configuration (theme, fonts, widget definitions)
├── core/
│   ├── defaults.nu    # Bar defaults & custom event registration
│   ├── icons.nu       # App and widget icon mappings
│   └── loader.nu      # Widget loader with auto-bracket/spacer wrapping
├── items/             # Widget registration scripts (define sketchybar items)
├── plugins/           # Widget update scripts (called by items on interval/event)
├── events/            # Custom event handlers (currently empty)
└── test/              # Test directory (currently empty)
```

## Architecture

### Entry Point Flow

```
sketchybarrc
    ├── use config.nu *         # Loads theme, fonts, widget definitions
    ├── use core/loader.nu *    # Loads load_widgets function
    ├── source core/defaults.nu # Applies bar defaults, registers events
    └── load_widgets            # Iterates widgets, calls item scripts
```

### Items vs Plugins

The configuration follows a clear separation of concerns:

**Items** (`items/*.nu`)

- Register widgets with sketchybar using `--add item`
- Define the script path pointing to the corresponding plugin
- Set initial styling (colors, fonts, padding)
- Subscribe to events (system_woke, front_app_switched, etc.)
- Receive configuration via `$env` from `config.nu`

**Plugins** (`plugins/*.nu`)

- Execute update logic when called by sketchybar
- Receive arguments via CLI parameters from the item's script path
- Use `sketchybar --set` to update icon/label values
- Handle data fetching and formatting

### Configuration Flow

```
config.nu (skenv.widgets)
       ↓
   $env variables
       ↓
items/<widget>.nu
       ↓
   script path construction
       ↓
plugins/<widget>.nu (CLI args)
```

## Widget Configuration

Widgets are defined in `config.nu` under `skenv.widgets`. Each widget shares common fields:

```nu
widget_name: {
  enable: true/false      # Whether to load the widget
  name: "widget_name"     # Widget identifier (must match items/<name>.nu)
  color: "0xAARRGGBB"     # Widget color (hex with alpha)
  side: left/center/right # Position on bar
  update_freq: 10         # Update interval in seconds (optional)
  icon_font: "Font:Style:Size" # Custom icon font (optional)
}
```

### Widget-Specific Fields

| Widget             | Special Fields                                                         |
| ------------------ | ---------------------------------------------------------------------- |
| `clock`            | `format` - strftime format string                                      |
| `aerospace`        | `color_focused`, `color_full`, `color_empty`, `label_pad`, `outer_pad` |
| `restart_notifier` | `threshold` - uptime threshold (e.g., "7day")                          |
| `volume`           | `right_pad` - right padding value                                      |
| `weather`          | `location`, `temp_unit`, `stale_threshold`                             |

### Side Ordering

Widgets are ordered "out to in" on each side, as defined in `config.nu`:

- **Left side** (outer to inner): `apple`, `aero_mode`, `aerospace`, `focused_app`, `docker`, `restart_notifier`
- **Right side** (outer to inner): `clock`, `volume`, `battery`, `mail`, `ai-usage`, `weather`

## Adding a New Widget

### Step 1: Add Widget Configuration

In `config.nu`, add your widget to `skenv.widgets`:

```nu
my_widget: {
  enable: true
  name: my_widget
  color: $"($theme.colors.blue)"
  update_freq: 30
  side: right
}
```

### Step 2: Create Item Script

Create `items/my_widget.nu`:

```nu
#!/usr/bin/env nu -n

def main [] {
  use ../core/icons.nu *
  let icon = icons widget my_icon_name
  let script = [
    ($env.CONFIG_DIR)/plugins/my_widget.nu
    $env.name
    $env.animation_type
    $env.animation_speed
  ] | str join " "

  sketchybar ...[
    --add item $env.name $env.side
    --animate $env.animation_type $env.animation_speed
    --set $env.name
    icon=($icon)
    icon.color=($env.color)
    label.color=($env.color)
    script=($script)
    update_freq=($env.update_freq)
    --subscribe $env.name system_woke
  ]
}
```

### Step 3: Create Plugin Script

Create `plugins/my_widget.nu`:

```nu
#!/usr/bin/env nu -n

def main [
  name: string           # Widget name
  animation_type: string # Animation type
  animation_speed: string # Animation speed
] {
  let value = "your computed value"

  sketchybar ...[
    --animate $animation_type $animation_speed
    --set $name
    label=($value)
  ]
}
```

### Step 4: Add Icon (Optional)

Add your widget icon to `core/icons.nu` in the `widget_icon` function:

```nu
"my_icon_name" => ""
```

## Theming

### Color Format

Colors use hex format with alpha channel: `0xAARRGGBB`

Transparency codes:

```
100%: 0xFF
 75%: 0xBF
 50%: 0x80
 25%: 0x40
  0%: 0x00
```

### Theme Colors

Defined in `config.nu` under `theme.colors`:

```nu
const theme = {
  name: "catppuccin-mocha"
  colors: {
    transparent: "0x00ffffff"
    light_gray:  "0xFFa6adc8"
    white:       "0xFFcdd6f4"
    red:         "0xFFf38ba8"
    yellow:      "0xFFf9e2af"
    blue:        "0xFF89b4fa"
    green:       "0xFFa6e3a1"
    magenta:     "0xFFf5c2e7"
    cyan:        "0xFF89dceb"
    orange:      "0xFFfab387"
    tangerine:   "0xFFeba0ac"
    purple:      "0xFF8b6baf"
    black:       "0xFF171723"
    black_75:    "0xBF171723"
  }
}
```

### Per-Widget Colors

Each widget in `skenv.widgets` has a `color` field that references the theme:

```nu
my_widget: {
  color: $"($theme.colors.blue)"
}
```

## Events

### Custom Events

Defined in `config.nu`:

```nu
custom_events: [
  aerospace_workspace_change
  opencode-completion
]
```

These are registered in `core/defaults.nu` and can be subscribed to in item scripts.

### Built-in Events

Common events used throughout:

| Event                 | Description                       |
| --------------------- | --------------------------------- |
| `system_woke`         | System wakes from sleep           |
| `front_app_switched`  | Focused application changes       |
| `volume_change`       | System volume changes             |
| `power_source_change` | Power source changes (battery/AC) |

### Subscribing to Events

In item scripts:

```nu
--subscribe $env.name system_woke front_app_switched
```

## Icon System

The `core/icons.nu` module provides two icon functions:

### Widget Icons

```nu
icons widget <icon_name>
```

Returns Nerd Font icons for widgets (battery, volume, clock, etc.).

### App Icons

```nu
icons app <app_name>
```

Returns [sketchybar-app-font](https://github.com/kvndrsslr/sketchybar-app-font) icons for applications. Includes:

- Direct matches for 350+ applications
- Alternative name matches (localized names, aliases)
- Regex patterns for versioned apps
- Default fallback icon

### Usage in Items

```nu
use ../core/icons.nu *
let icon = icons widget clock
let app_icon = icons app "Google Chrome"
```

## Automatic Styling

The loader (`core/loader.nu`) automatically:

1. **Wraps widgets in brackets** - Adds rounded background containers
2. **Adds spacers** - Inserts spacing between widgets
3. **Applies animations** - Uses animation settings from config

Bracket defaults:

```nu
bracket: {
  height: 28
  color: "0xBF171723"  # 75% transparent black
  corner_radius: 4
  border_width: 1
}
```

## Fonts

Defined in `config.nu`:

```nu
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
```

## Bar Defaults

Configured in `config.nu`:

```nu
defaults: {
  bar: {
    height: 56
    y_offset: -10
    position: top
    color: transparent
  }
  label: {
    font: $fonts.label
    padding: { left: 0, right: 8 }
    color: transparent
  }
  icon: {
    font: $fonts.icon
    padding: { left: 8, right: 6 }
    color: transparent
  }
}
```

## Conventions

### Shebang

All Nushell scripts use:

```nu
#!/usr/bin/env nu -n
```

The `-n` flag ensures a clean environment.

### Script Path Construction

Items construct plugin paths using `$env.CONFIG_DIR`:

```nu
let script = [
  ($env.CONFIG_DIR)/plugins/widget_name.nu
  $env.name
  $env.animation_type
  $env.animation_speed
] | str join " "
```

### Sketchybar Commands

Use the spread operator for multi-argument commands:

```nu
sketchybar ...[
  --add item $name $side
  --set $name
  icon.color=($color)
  label=($value)
]
```
