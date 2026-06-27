# My Configuration

Personal dotfiles and system configuration managed with GNU Stow.

## File Structure

```
dotfiles/
├── *.pkd/          Configuration packages (stow-compatible)
├── data/           Exported configs (Brewfile, Cronjobs, keychron)
├── dot             Dotfiles manager script (wraps GNU Stow)
├── docs/           Documentation
└── misc/           Themes and wallpapers
```

- `*.pkd/` - Stow packages containing application configurations
- `data/` - Exported system configurations for backup
- `dot` - Convenience wrapper around GNU Stow for managing symlinks
- `docs/` - Detailed setup and usage documentation
- `misc/` - Visual assets (themes, wallpapers)

## Documentation

- [Setup](./docs/setup.md) - Initial installation and configuration (Homebrew, Touch ID, Nushell)
- [Dotfiles Management](./docs/dotfiles-stow.md) - Managing configuration symlinks with `./dot`
- [Cronjobs](./docs/cronjobs.md) - Scheduled tasks backup
- [Yubikey](./docs/yubikey.md) - Yubikey setup and SSH usage
- [TDF](./docs/pdf-viewer.md) - TUI pdf viewer
