# Karabiner Elements

Used for rebinding keys on macos, at the system level.

## Requirements

Macos setting: `System Settings -> Keyboard -> Keyboard Shortcuts -> Function Keys -> Use F1, F2, etc. keys as standard function keys` -> _True_

## Complex Modifications

### Hyper Key

Remaps caps to mod tap behavior:

- tap: escape
- hold: hyper key (cmd + opt + ctrl)

### Function Keys

For built-in keyboard.

When the above macos setting is false, external keyboards cannot send raw function keypresses without them being converted to media controls. When the setting is true, the f keys on the default keyboard require `fn` to use media controls.

This inverts the function key behavior so that the macbook keyboard has easy media controls, AND external keyboards can send function keys.

### Disable Hiding

This disabled the `Cmd+H` hiding window behavior (conflicts with window managers).

### Additional Media Key Access

This maps unused function keys (20-24) to useful macos media keys. This has to be done as macos checks keyboard vendor IDs and does not accept `mission control` for example from non-apple devices.
