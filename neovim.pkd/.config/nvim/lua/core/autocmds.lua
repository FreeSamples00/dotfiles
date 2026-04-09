local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local general = augroup("General", { clear = true })
local globals = require("helpers.globals")

-- Initialize auto-format setting
vim.g.autoformat_enabled = true

----- special rules for text heavy filetypes -----
autocmd("FileType", {
  group = general,
  pattern = globals.text_filetypes,
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en"
    vim.opt_local.wrap = true
    vim.opt_local.textwidth = 0
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.showbreak = "󱞩 "
    vim.opt_local.formatoptions:remove("t")
    vim.opt_local.formatoptions:remove("c")
  end,
})

----- Auto generate spell files as needed -----
autocmd("VimEnter", {
  group = general,
  callback = function()
    local config_path = vim.fn.stdpath("config")
    local spell_dir = config_path .. "/spell"

    if vim.fn.isdirectory(spell_dir) == 0 then
      return
    end

    local add_files = vim.fn.glob(spell_dir .. "/*.add", false, true)

    for _, add_file in ipairs(add_files) do
      local spl_file = add_file .. ".spl"

      if vim.fn.filereadable(spl_file) == 0 then
        vim.cmd.mkspell({ add_file, bang = false })
      end
    end
  end,
})

----- Highlight on yank -----
autocmd("TextYankPost", {
  group = general,
  desc = "Highlight when yanking text",
  callback = function()
    (vim.hl or vim.highlight).on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

----- Auto-format on save -----
autocmd("BufWritePre", {
  group = general,
  desc = "Auto-format on save",
  callback = function()
    if vim.g.autoformat_enabled ~= false then
      vim.lsp.buf.format({ timeout_ms = 1000 })
    end
  end,
})
