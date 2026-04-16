return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        preset = "helix",
        notify = true,
        keys = {
          scroll_down = "<c-d>",
          scroll_up = "<c-u>",
        },
      })
      wk.add({
        { "<leader>h", group = "Harpoon" },
        { "<leader>d", group = "Delete/Close" },
        { "<leader>f", group = "File" },
        { "<leader>g", group = "Git" },
        { "<leader>l", group = "LSP" },
        { "<leader>q", group = "Quit" },
        { "<leader>s", group = "Search" },
        { "<leader>u", group = "UI" },
        { "<leader>b", group = "Buffers" },
      })
    end,
  },
}
