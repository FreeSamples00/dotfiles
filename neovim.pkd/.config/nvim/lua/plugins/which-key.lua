return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    notify = true,
    keys = { scroll_down = "<c-d>", scroll_up = "<c-u>" },
    icons = { mappings = false, group = "" },
  },
  config = function(_, opts)
    require("which-key").setup(opts)
    require("which-key").add({
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
}
