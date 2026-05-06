# Dotfiles Management

Configuration files are managed using [GNU Stow](https://www.gnu.org/software/stow/), wrapped by the `./dot` script for convenience.

## Package Structure

Each application's configuration is stored in a `*.pkd` (package) directory:

```
dotfiles/
├── bash.pkd/
│   ├── .hushlogin
│   └── dot-bashrc
├── neovim.pkd/
│   └── .config/
│       └── nvim/
├── git.pkd/
│   ├── dot-gitconfig
│   └── dot-gitignore
└── ...
```

The `dot-` prefix maps to `.` in your home directory (e.g., `dot-bashrc` → `.bashrc`).

## The `./dot` Script

The `./dot` script wraps GNU Stow with sensible defaults:

### Stow Packages

_**NOTE:** You can manually select packages to link, see `./dot stow -h`_

1. Remove any stale symlinks or conflicting config files
2. Run `./dot stow -t -a` (this will tell you if there are any conflicts)
3. Ensure all proposed links look good
4. Run `./dot stow -a`

### Options

| Option          | Description                             |
| --------------- | --------------------------------------- |
| `-h, --help`    | Show help message                       |
| `-a, --all`     | Stow all packages                       |
| `-t, --test`    | Testing mode, no changes to file system |
| `-e, --exclude` | Exclude specified packages              |
| `-d, --delete`  | Delete existing symlinks                |

### Examples

Stow all packages:

```bash
./dot stow -a
```

Stow specific packages:

```bash
./dot stow neovim git bash
```

Test stow without making changes:

```bash
./dot stow -t -a
```

Stow all packages except one:

```bash
./dot stow -a -e sketchybar
```

## Dump Configs

Export current configurations:

```bash
./dot dump
```

This creates:

- `_dumps/Brewfile` - List of brew packages
- `_dumps/Cronjobs` - Crontab settings
