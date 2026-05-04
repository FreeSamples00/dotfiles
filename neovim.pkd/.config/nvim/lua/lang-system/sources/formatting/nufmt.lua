local methods = require("null-ls.methods")
local h = require("null-ls.helpers")

local FORMATTING = methods.internal.FORMATTING

return h.make_builtin({
  -- install with: cargo install --git https://github.com/nushell/nufmt
  name = "nufmt",
  meta = {
    url = "https://github.com/nushell/nufmt",
    description = "Nushell code formatter",
  },
  method = FORMATTING,
  filetypes = { "nu" },
  generator_opts = {
    command = "nufmt",
    args = { "--stdin" },
    to_stdin = true,
  },
  factory = h.formatter_factory,
})
