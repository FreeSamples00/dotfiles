-- https://github.com/folke/snacks.nvim

return vim.tbl_deep_extend(
  "force",
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      image = { enabled = true, doc = { inline = false, float = false } },
      animate = { enable = true },
      bigfile = { enabled = true },
      explorer = { enabled = true },
      indent = {
        enabled = true,
        chunk = {
          enabled = true,
        },
      },
      input = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {
          wo = require("helpers.utils").wrap_options,
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
