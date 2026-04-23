-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    settings = {
      save_on_toggle = true,
      sync_on_ui_close = true,
    },
  },
  keys = {
    {
      "<leader>a",
      function()
        require("harpoon"):list():add()
      end,
      desc = "Harpoon Add",
    },
    {
      "H",
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
    {
      "<leader>1",
      function()
        require("harpoon"):list():select(1)
      end,
    },
    {
      "<leader>2",
      function()
        require("harpoon"):list():select(2)
      end,
    },
    {
      "<leader>3",
      function()
        require("harpoon"):list():select(3)
      end,
    },
    {
      "<leader>4",
      function()
        require("harpoon"):list():select(4)
      end,
    },
    {
      "<leader>5",
      function()
        require("harpoon"):list():select(5)
      end,
    },
    {
      "<leader>6",
      function()
        require("harpoon"):list():select(6)
      end,
    },
    {
      "<leader>7",
      function()
        require("harpoon"):list():select(7)
      end,
    },
    {
      "<leader>8",
      function()
        require("harpoon"):list():select(8)
      end,
    },
    {
      "<leader>9",
      function()
        require("harpoon"):list():select(9)
      end,
    },
  },
}
