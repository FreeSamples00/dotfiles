return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      nushell = {},  -- Empty table works, or can use `nushell = { mason = false }`
    },
  },
}
