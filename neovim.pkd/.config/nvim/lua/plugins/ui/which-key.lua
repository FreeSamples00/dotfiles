--- Which-key: keybind discovery popup with Helix-style preset and low delay

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>?", "<cmd>WhichKey<CR>", desc = "Keybind Popup", mode = { "n", "v" } },
  },
  opts = {
    preset = "helix", -- Helix-style popup layout
    notify = true,
    keys = { scroll_down = "<c-d>", scroll_up = "<c-u>" },
    icons = { mappings = false, group = "" }, -- no icon noise
    delay = 5, -- near-instant popup
    -- In operator-pending and visual modes, only show whitelisted keys.
    -- All other keys still work — they just don't appear in the popup.
    -- Uses prefix matching so children of whitelisted groups (af, ic, [h, etc.) also show.
    filter = function(map)
      if vim.tbl_contains({ "o", "x", "v" }, map.mode) then
        local whitelist = {
          "a", -- mini.ai "around"
          "i", -- mini.ai "inside"
          "s", -- Flash
          "[", -- prev navigation
          "]", -- next navigation
        }
        for _, prefix in ipairs(whitelist) do
          if vim.startswith(map.lhs, prefix) then
            return true
          end
        end
        return false
      end
      return true
    end,
    spec = {
      -- leader groups
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
      { "<leader>1", desc = "Harpoon Jump (1-9)" },
      { "<leader>2", hidden = true },
      { "<leader>3", hidden = true },
      { "<leader>4", hidden = true },
      { "<leader>5", hidden = true },
      { "<leader>6", hidden = true },
      { "<leader>7", hidden = true },
      { "<leader>8", hidden = true },
      { "<leader>9", hidden = true },

      -- navigation groups
      { "[", group = "prev", mode = { "n", "o", "x" } },
      { "]", group = "next", mode = { "n", "o", "x" } },

      -- visual mode group
      { "v", group = "visual select", mode = "n" },

      -- z group: visible for spell/scroll, fold sub-keys hidden
      { "z", group = "spell/scroll", mode = "n" },
      { "za", hidden = true, mode = "n" },
      { "zc", hidden = true, mode = "n" },
      { "zd", hidden = true, mode = "n" },
      { "zD", hidden = true, mode = "n" },
      { "zE", hidden = true, mode = "n" },
      { "zf", hidden = true, mode = "n" },
      { "zi", hidden = true, mode = "n" },
      { "zm", hidden = true, mode = "n" },
      { "zM", hidden = true, mode = "n" },
      { "zn", hidden = true, mode = "n" },
      { "zN", hidden = true, mode = "n" },
      { "zo", hidden = true, mode = "n" },
      { "zO", hidden = true, mode = "n" },
      { "zr", hidden = true, mode = "n" },
      { "zR", hidden = true, mode = "n" },
      { "zx", hidden = true, mode = "n" },
      { "zX", hidden = true, mode = "n" },
      { "zA", hidden = true, mode = "n" },
      { "zC", hidden = true, mode = "n" },
    },
  },
}
