--- Snacks.nvim: all-in-one utility plugin (dashboard, explorer, picker, indent, scroll, etc.)
--- Sub-module specs are merged into one lazy spec via vim.tbl_deep_extend

return vim.tbl_deep_extend(
  "force",
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      image = { enabled = true, doc = { inline = false, float = false } }, -- image support, no inline display
      animate = { enable = true },
      bigfile = { enabled = true }, -- disable features for large files
      explorer = { enabled = true },
      indent = {
        enabled = true,
        chunk = { enabled = true }, -- chunk highlighting for code blocks
      },
      input = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true }, -- fast loading for pre-read buffers
      scope = { enabled = true },
      scroll = { enabled = true }, -- smooth scrolling
      statuscolumn = { enabled = true }, -- line numbers + signs + folds
      words = { enabled = true }, -- LSP reference highlighting
      styles = {
        notification = {
          wo = require("helpers.utils").wrap_options, -- wrapped text in notifications
          width = { min = 20, max = 60 },
          height = { min = 1, max = 10 },
        },
      },
    },
  },
  require("plugins.snacks.dashboard"),
  require("plugins.snacks.picker"),
  require("plugins.snacks.keys"),
  require("plugins.snacks.setup")
)
