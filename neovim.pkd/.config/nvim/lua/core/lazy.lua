--- Bootstrap lazy.nvim and load plugin specs from lua/plugins/
--- Leader key must be set before lazy.setup so key mappings resolve correctly

-- install lazy.nvim if missing
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local ok, lazy = pcall(require, "lazy")
if not ok then
  return
end

-- set leader before plugin loading (see helpers.keys.set_leaders)
require("helpers.keys").set_leaders(" ", "\\")

lazy.setup("plugins", {
  checker = {
    enabled = true, -- check for updates on startup
    notify = false, -- don't spam notifications
  },
  ui = {
    border = "rounded",
  },
})

require("helpers.keys").map("n", "<leader>dL", lazy.show, "Lazy UI")
