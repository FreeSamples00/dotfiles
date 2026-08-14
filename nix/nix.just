# === Nix Commands ===

_default:
    @just --unsorted --list nix

# Build (dry-run, no activation)
[group('build')]
build profile='default':
    {{ if profile == 'mac' { 'sudo darwin-rebuild build --flake ".#scc-mac"' } else { 'home-manager build --flake ".#scc-{{ profile }}"' } }}

# Deploy configuration
[group('deploy')]
deploy profile='default':
    {{ if profile == 'mac' { 'sudo darwin-rebuild switch --flake ".#scc-mac"' } else { 'home-manager switch --flake ".#scc-{{ profile }}" -b backup' } }}

# Rollback to previous generation
[group('deploy')]
rollback profile='default':
    {{ if profile == 'mac' { 'sudo darwin-rebuild rollback' } else { 'home-manager rollback' } }}

# List generations
[group('deploy')]
generations profile='default':
    {{ if profile == 'mac' { 'darwin-rebuild --list-generations' } else { 'home-manager generations' } }}

# Update flake inputs
[group('maintenance')]
update:
    nix flake update

# Garbage collect old generations (keep last N days)
[group('maintenance')]
gc keep='5':
    nix-collect-garbage --delete-older-than {{ keep }}d

# Evaluate a Nix expression
[group('dev')]
eval expr:
    nix eval --impure --expr '{{ expr }}'

# Check flake for errors
[group('dev')]
check:
    nix flake check
