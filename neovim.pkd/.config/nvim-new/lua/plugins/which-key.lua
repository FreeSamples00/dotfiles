return {
  {
    "folke/which-key.nvim",
    config = function()
      local wk = require("which-key")
      wk.setup({
        keys = {
          scroll_down = "<c-j>",
          scroll_up = "<c-k>",
        },
      })
      wk.add({
        -- { "<leader>b", group = "Debugging" },
        { "<leader>h", group = "Harpoon" },
        { "<leader>d", group = "Delete/Close" },
        { "<leader>f", group = "File" },
        { "<leader>g", group = "Git" },
        { "<leader>l", group = "LSP" },
        { "<leader>q", group = "Quit" },
        { "<leader>s", group = "Search" },
        { "<leader>u", group = "UI" },
      })
    end,
  },
}
