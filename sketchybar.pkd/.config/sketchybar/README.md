# sketchybar config

> [!NOTE]: Originally forked from [zerochae/sketchybar-gray](https://github.com/zerochae/sketchybar-gray) on commit `2d89512c818ba62621f36738cf359f84665c8992` - has since diverged significantly

Custom macOS menu bar configuration for sketchybar, using Aerospace for workspace management.

## Dependencies

- [sketchybar](https://github.com/FelixKratz/SketchyBar) - Customizable status bar
- [aerospace](https://github.com/nikitabobko/AeroSpace) - Tiling window manager
- [sketchybar-app-font](https://github.com/kvndrsslr/sketchybar-app-font) - App icon font

## Active Widgets

**Left:**

- `apple` - Apple logo
- `aerospace` - Workspace manager
- `front_app` - Current application
- `restart_notifier` - Configuration update indicator

**Right:**

- `clock` - Time display
- `weather` - Weather via wttr.in
- `volume` - Volume control with toggle
- `caffeinate` - Sleep prevention toggle
- `battery` - Battery status

## Configuration

|         Path          | Desc                                          |
| :-------------------: | :-------------------------------------------- |
| `./user.sketchybarrc` | export config variables                       |
|      `./items/`       | Place item init scripts                       |
|     `./plugins/`      | Place item update scripts                     |
|      `./events/`      | Place event scripts (onclick, other triggers) |
|  `./tokens/themes/`   | Place theme files                             |
