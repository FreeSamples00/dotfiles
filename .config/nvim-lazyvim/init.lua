-- bootstrap lazy.nvim, LazyVim and your plugins

if vim.g.neovide then
  vim.g.neovide_font_features = "liga=0, dlig=0"
  vim.o.guifont = "JetBrainsMono Nerd Font Mono:h18"
  vim.g.neovide_window_focused = "transparent"
end

require("config.lazy")
