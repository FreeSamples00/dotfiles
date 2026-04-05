-- plugins that background highlight
return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      lazy_load = true,
      parsers = {
        names = { enable = false },
        xterm = { enable = true },
      },
    },
  }
}
