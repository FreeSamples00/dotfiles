--- nvim-colorizer: inline color previews for hex/xterm codes (no CSS names)

return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {
    lazy_load = true,
    parsers = {
      names = { enable = false }, -- no CSS named colors
      xterm = { enable = true }, -- xterm 256-color codes
      hex = {
        aarrggbb = true, -- 8-digit hex with alpha
      },
    },
  },
}
