return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>?", "<cmd>WhichKey<CR>", desc = "Keybind Popup", mode = { "n", "v" } },
  },
  opts = {
    preset = "helix",
    notify = true,
    keys = { scroll_down = "<c-d>", scroll_up = "<c-u>" },
    icons = { mappings = false, group = "" },
    delay = 5,
    spec = {
      -- Group definitions
      { "<leader>f", group = "File" },
      { "<leader>b", group = "Buffer" },
      { "<leader>g", group = "Git" },
      { "<leader>h", group = "Harpoon" },
      { "<leader>s", group = "Search" },
      { "<leader>u", group = "UI" },
      { "<leader>l", group = "LSP" },
      { "<leader>d", group = "Dev Tools" },
      { "<leader>dl", group = "Languages" },
      { "<leader>M", group = "Markdown" },

      -- Harpoon description overrides
      { "<leader>1", desc = "Harpoon Jump (1-9)" },
      { "<leader>2", hidden = true },
      { "<leader>3", hidden = true },
      { "<leader>4", hidden = true },
      { "<leader>5", hidden = true },
      { "<leader>6", hidden = true },
      { "<leader>7", hidden = true },
      { "<leader>8", hidden = true },
      { "<leader>9", hidden = true },
    },
  },
}
