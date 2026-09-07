--- Harpoon v2: quick file marking for fast switching between pinned files
--- save_on_toggle + sync_on_ui_close persist marks automatically

local keys = {
  {
    "<leader>a",
    function()
      require("harpoon"):list():add()
    end,
    desc = "Harpoon Add",
  },
  {
    "<leader>H",
    function()
      require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
    end,
    desc = "Harpoon Menu",
  },
  {
    "<leader>ha",
    function()
      require("harpoon"):list():add()
    end,
    mode = { "n", "x" },
    desc = "Append File",
  },
  {
    "<leader>hA",
    function()
      require("harpoon"):list():prepend()
    end,
    mode = { "n", "x" },
    desc = "Prepend File",
  },
  {
    "<leader>hd",
    function()
      require("harpoon"):list():remove()
    end,
    mode = { "n", "x" },
    desc = "Remove File",
  },
  {
    "<leader>h]",
    function()
      require("harpoon"):list():next()
    end,
    desc = "Next",
  },
  {
    "<leader>h[",
    function()
      require("harpoon"):list():prev()
    end,
    desc = "Previous",
  },
}

-- jump to harpooned file by index (which-key spec handles display names)
for i = 1, 9 do
  keys[#keys + 1] = {
    ("<leader>%d"):format(i),
    function()
      require("harpoon"):list():select(i)
    end,
  }
end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    settings = {
      save_on_toggle = true, -- save when closing menu
      sync_on_ui_close = true, -- sync on any UI close
    },
  },
  keys = keys,
}
