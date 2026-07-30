_default:
    @just --unsorted --list skbar

_kill:
    pgrep -i "sketchybar" | xargs kill

# Launch sketchybar
[group('Running')]
start: _kill
    nohup sketchybar &>/dev/null &

# Stop sketchybar
[group('Running')]
stop: _kill

# Test w/ output
[group('Testing')]
test: _kill
    sketchybar

# Test w/ output - exits after launch
[group('Testing')]
test-auto timeout="2": _kill
    sketchybar & sleep {{ timeout }}
    just skbar _kill

# Apply executable permissions to all files
[group('Dev')]
perm:
    find . -name "*.nu" -type f -exec chmod +x {} +
    chmod +x sketchybarrc

# Reload sketchybar configuration
[group('Dev')]
reload:
    sketchybar --reload

# Query current bar properties
[group('Dev')]
query-bar:
    sketchybar --query bar

# Query specific item properties by name
[group('Dev')]
query-item name:
    sketchybar --query {{ name }}
# Query default item properties

[group('Dev')]
query-defaults:
    sketchybar --query defaults

# List all registered events
[group('Dev')]
query-events:
    sketchybar --query events

# Manually trigger a custom event with optional args
[group('Dev')]
trigger event *args:
    sketchybar --trigger {{ event }} {{ args }}
