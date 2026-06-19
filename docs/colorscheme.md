# Colorscheme

Personal color palette derived from Catppuccin Mocha.

Evolution:
Catppuccin Mocha (dimmed tier)
→ RGB midpoint with perceptual tuning (normal tier)
→ Boosted saturation, same hue family (bright tier)
→ Generic color names (tool-agnostic)
→ Swap values from Nix, no tool config changes needed

Accents use color identity names with optional
`-dimmed` / `-bright` suffix (unsuffixed = normal).
Structural and background colors use purpose names.
Derived colors use purpose names for tool-specific values.

Source: <https://catppuccin.com/palette/mocha>

## Accent Colors

| Name     | dimmed    | normal    | bright    |
| -------- | --------- | --------- | --------- |
| coral    | `#f5e0dc` | `#f3b8b0` | `#f09898` |
| salmon   | `#f2cdcd` | `#f0aaaa` | `#ee8888` |
| pink     | `#f5c2e7` | `#ee9dd4` | `#e878c0` |
| purple   | `#cba6f7` | `#c490f0` | `#b080f0` |
| red      | `#f38ba8` | `#ee668c` | `#e84070` |
| red-soft | `#eba0ac` | `#e67c92` | `#e05878` |
| orange   | `#fab387` | `#f59a64` | `#f08040` |
| yellow   | `#f9e2af` | `#f0d57c` | `#e8c84a` |
| green    | `#a6e3a1` | `#8ae28e` | `#6de07a` |
| teal     | `#94e2d5` | `#6addca` | `#40d8c0` |
| cyan     | `#89dceb` | `#6cd2ea` | `#50c8e8` |
| azure    | `#74c7ec` | `#67c0ea` | `#5ab8e8` |
| blue     | `#89b4fa` | `#7aacf9` | `#6aa4f8` |
| lilac    | `#b4befe` | `#a29ffb` | `#9080f8` |

## Structural Colors

| Name           | Hex       |
| -------------- | --------- |
| fg             | `#cdd6f4` |
| fg-secondary   | `#bac2de` |
| fg-muted       | `#a6adc8` |
| fg-faint       | `#9399b2` |
| border         | `#7f849c` |
| border-muted   | `#6c7086` |
| surface-raised | `#585b70` |
| surface        | `#45475a` |
| surface-sunken | `#313244` |

## Background Colors (Transparency Override)

| Name         | Catppuccin | Override  |
| ------------ | ---------- | --------- |
| bg           | `#1e1e2e`  | `#1E1E1E` |
| bg-secondary | `#181825`  | `#141414` |
| bg-deep      | `#11111b`  | `#0A0A0A` |

## Derived Colors

Tool-specific values named by purpose. Not generated from accent tiers.

| Name            | Hex       | Purpose                              |
| --------------- | --------- | ------------------------------------ |
| cursor          | `#CBD6F7` | Ghostty terminal cursor              |
| git-branch      | `#f06040` | Starship git branch indicator        |
| diff-file       | `#7aacf9` | Delta file path header               |
| diff-hunk       | `#f0d57c` | Delta hunk header                    |
| diff-hint       | `#9399b2` | Delta inline hints                   |
| diff-separator  | `#7f849c` | Delta blame separator                |
| diff-minus      | `#660000` | Delta deletion background            |
| diff-minus-emph | `#8b3030` | Delta deletion emphasis background   |
| diff-plus       | `#0e2e1e` | Delta addition background            |
| diff-plus-emph  | `#1a4a2a` | Delta addition emphasis background   |
| diff-blame-1    | `#3d3d4d` | Delta blame gradient (lightest)      |
| diff-blame-2    | `#383846` | Delta blame gradient                 |
| diff-blame-3    | `#34343f` | Delta blame gradient                 |
| diff-blame-4    | `#303038` | Delta blame gradient                 |
| diff-blame-5    | `#2c2c31` | Delta blame gradient (darkest)       |
| focus-dnd       | `#6d7cff` | Focus mode: Do Not Disturb indicator |
| focus-sleep     | `#14b6a4` | Focus mode: Sleep indicator          |
| focus-reduce    | `#db34f2` | Focus mode: Reduce Interruptions     |

## Catppuccin Mocha Mapping

Reference mapping for provenance.

| Generic Name   | Catppuccin Mocha |
| -------------- | ---------------- |
| coral          | rosewater        |
| salmon         | flamingo         |
| pink           | pink             |
| purple         | mauve            |
| red            | red              |
| red-soft       | maroon           |
| orange         | peach            |
| yellow         | yellow           |
| green          | green            |
| teal           | teal             |
| cyan           | sky              |
| azure          | sapphire         |
| blue           | blue             |
| lilac          | lavender         |
| fg             | text             |
| fg-secondary   | subtext1         |
| fg-muted       | subtext0         |
| fg-faint       | overlay2         |
| border         | overlay1         |
| border-muted   | overlay0         |
| surface-raised | surface2         |
| surface        | surface1         |
| surface-sunken | surface0         |
| bg             | base             |
| bg-secondary   | mantle           |
| bg-deep        | crust            |

## 0xAARRGGBB Format

For tools using alpha-prefixed format (sketchybar, jankyborders).

### Accent Colors

| Name     | dimmed 0xAARRGGBB | normal 0xAARRGGBB | bright 0xAARRGGBB |
| -------- | ----------------- | ----------------- | ----------------- |
| coral    | `0xfff5e0dc`      | `0xfff3b8b0`      | `0xfff09898`      |
| salmon   | `0xfff2cdcd`      | `0xfff0aaaa`      | `0xffee8888`      |
| pink     | `0xfff5c2e7`      | `0xffee9dd4`      | `0xffe878c0`      |
| purple   | `0xffcba6f7`      | `0xffc490f0`      | `0xffb080f0`      |
| red      | `0xfff38ba8`      | `0xffee668c`      | `0xffe84070`      |
| red-soft | `0xffeba0ac`      | `0xffe67c92`      | `0xffe05878`      |
| orange   | `0xfffab387`      | `0xfff59a64`      | `0xfff08040`      |
| yellow   | `0xfff9e2af`      | `0xfff0d57c`      | `0xffe8c84a`      |
| green    | `0xffa6e3a1`      | `0xff8ae28e`      | `0xff6de07a`      |
| teal     | `0xff94e2d5`      | `0xff6addca`      | `0xff40d8c0`      |
| cyan     | `0xff89dceb`      | `0xff6cd2ea`      | `0xff50c8e8`      |
| azure    | `0xff74c7ec`      | `0xff67c0ea`      | `0xff5ab8e8`      |
| blue     | `0xff89b4fa`      | `0xff7aacf9`      | `0xff6aa4f8`      |
| lilac    | `0xffb4befe`      | `0xffa29ffb`      | `0xff9080f8`      |

### Structural Colors

| Name           | Hex       | 0xAARRGGBB   |
| -------------- | --------- | ------------ |
| fg             | `#cdd6f4` | `0xffcdd6f4` |
| fg-secondary   | `#bac2de` | `0xffbac2de` |
| fg-muted       | `#a6adc8` | `0xffa6adc8` |
| fg-faint       | `#9399b2` | `0xff9399b2` |
| border         | `#7f849c` | `0xff7f849c` |
| border-muted   | `#6c7086` | `0xff6c7086` |
| surface-raised | `#585b70` | `0xff585b70` |
| surface        | `#45475a` | `0xff45475a` |
| surface-sunken | `#313244` | `0xff313244` |

### Background Colors

| Name         | Override  | 0xAARRGGBB   |
| ------------ | --------- | ------------ |
| bg           | `#1E1E1E` | `0xff1e1e1e` |
| bg-secondary | `#141414` | `0xff141414` |
| bg-deep      | `#0A0A0A` | `0xff0a0a0a` |
