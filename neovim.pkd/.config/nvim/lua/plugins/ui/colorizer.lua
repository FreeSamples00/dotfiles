return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {
    lazy_load = true,
    parsers = {
      names = { enable = false },
      xterm = { enable = true },
      hex = {
        aarrggbb = true,
      },
    },
  },
}
