-- Miscelaneous fun stuff
return {
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "echasnovski/mini.move",
    event = "VeryLazy",
    config = function()
      require("mini.move").setup()
    end,
  },

  {
    "tpope/vim-sleuth",
    event = "BufReadPost",
  },
  {
    "tpope/vim-surround",
    event = "VeryLazy",
  },
}
