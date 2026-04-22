# NEOVIM

## UI / UX

### Snacks.nvim

All-in-one utility plugin providing:

- **Dashboard**: Startup screen with plugin load stats and quick actions
- **Explorer**: File browser (`<leader>e`)
- **Picker**: Fuzzy finder for files, buffers, grep, git, LSP symbols, diagnostics, marks, registers, keymaps, commands, help, undo history, colorschemes
- **Indent**: Indent guides with chunk highlighting
- **Notifier**: Notification UI with wrapped text
- **Scroll**: Smooth scrolling
- **Statuscolumn**: Line numbers, signs, fold markers
- **Words**: LSP reference highlighting with `]]`/`[[` navigation
- **Bigfile**: Automatic handling of large files
- **Quickfile**: Fast file loading
- **Toggle mappings**: `<leader>u` prefix for spell, wrap, relativenumber, diagnostics, conceal, treesitter, inlay hints, indent

### Noice

Enhanced UI for messages, cmdline, and popupmenu:

- Command palette preset (cmdline + popupmenu positioned together)
- LSP hover docs and signature help with borders
- Long messages sent to split

### Lualine

Custom statusline with:

- Mode indicator
- Filename with modified/readonly/newfile symbols
- Git diff stats
- Macro recording indicator (shows register when recording)
- SSH connection indicator
- Diagnostics (error, warn, hint, info)
- Progress percentage
- Clock

### Themes

Catppuccin-mocha (default) with transparent background. Also includes: gruvbox, rose-pine, everforest, melange, bg.nvim

### Highlighting

- **todo-comments**: Highlights TODO/FIX/XXX in comments, searchable via `<leader>st`/`<leader>sT`
- **nvim-colorizer**: Displays color codes inline (xterm colors, no CSS names)

### Git

- **gitsigns**: Git hunks in signcolumn

## Navigation

### Harpoon (v2)

Quick file marking for fast switching between frequently used files:

| Key | Action |
|-----|--------|
| `<leader>a` | Add file to harpoon |
| `H` | Toggle harpoon menu |
| `<leader>ha` | Append file |
| `<leader>hA` | Prepend file |
| `<leader>hd` | Remove file |
| `<leader>h[` / `h]` | Prev/next harpooned file |
| `<leader>1-9` | Jump to harpooned file |

### Snacks Pickers

| Key | Action |
|-----|--------|
| `<leader><space>` | Smart find files |
| `L` | Buffer list |
| `<leader>/` | Grep |
| `<leader>e` | File explorer |
| `<leader>fb` | Buffers |
| `<leader>fc` | Find config file |
| `<leader>sf` | Files |
| `<leader>sr` | Recent files |
| `<leader>m` | Marks |
| `<leader>r` | Registers |
| `<leader>U` | Undo history |

## Nice to Haves

### minipairs

Auto-pairing for brackets and quotes. Configured to skip pairing after word characters (e.g., `foo"` won't add closing quote).

### which-key

Keybind discovery popup with Helix preset. Press `<leader>?` to show all keymaps. Groups: `<leader>f` (File), `<leader>g` (Git), `<leader>h` (Harpoon), `<leader>s` (Search), `<leader>u` (UI), `<leader>l` (LSP), `<leader>d` (Dev Tools), `<leader>M` (Markdown).

### lazygit

Integrated via Snacks (`<leader>gg`).

### Autocompletion (nvim-cmp)

Sources: LSP, LuaSnip, buffer, path. Tab/S-Tab for navigation, CR to confirm.

### Misc

- **Comment.nvim**: Toggle comments
- **mini.move**: Move text with Alt+hjkl
- **vim-sleuth**: Auto-detect indentation
- **vim-surround**: Surround text objects with brackets/quotes

### Markdown

- **render-markdown.nvim**: Pretty markdown rendering with heading blocks, checkboxes, code blocks
- **bullets.vim**: Automatic bullet lists, checkbox toggling (`<C-x>`), indentation (`<C-,>`/`<C-.>`)

## Language Tooling

See [lua/lang-system/README.md](lua/lang-system/README.md) for the language system documentation.

This system handles declarative configuration of these language tools:

- Treesitter
- LSP
- Formatter
- Linter
- DAP
