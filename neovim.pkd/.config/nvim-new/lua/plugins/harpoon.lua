-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("harpoon"):setup()
  end,
  keys = {
    {
      "<leader>a",
      function()
        require("harpoon"):list():add()
      end,
      desc = "Harpoon: Add mark",
    },
    {
      "H",
      function()
        require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
      end,
      desc = "Harpoon: Toggle quick menu",
    },
    {
      "<leader>1",
      function()
        require("harpoon"):list():select(1)
      end,
      desc = "Harpoon: Jump to mark 1",
    },
    {
      "<leader>2",
      function()
        require("harpoon"):list():select(2)
      end,
      desc = "Harpoon: Jump to mark 2",
    },
    {
      "<leader>3",
      function()
        require("harpoon"):list():select(3)
      end,
      desc = "Harpoon: Jump to mark 3",
    },
    {
      "<leader>4",
      function()
        require("harpoon"):list():select(4)
      end,
      desc = "Harpoon: Jump to mark 4",
    },
    {
      "<leader>hm",
      function()
        require("harpoon"):list():append()
      end,
      mode = { "n", "x" },
      desc = "Harpoon: Mark file",
    },
    {
      "[h",
      function()
        require("harpoon"):list():prev()
      end,
      desc = "Harpoon: Previous mark",
    },
    {
      "]h",
      function()
        require("harpoon"):list():next()
      end,
      desc = "Harpoon: Next",
    },
  },
}
