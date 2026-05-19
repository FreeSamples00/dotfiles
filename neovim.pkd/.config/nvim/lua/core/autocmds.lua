--- Autocommands: format-on-save, text filetype rules, yank highlight, spell file generation

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local general = augroup("General", { clear = true })
local globals = require("helpers.globals")

-- cross-module global: toggled by <leader>uf in snacks/setup.lua
vim.g.autoformat_enabled = true

----- Text-heavy filetype rules (see helpers.globals.text_filetypes) -----
autocmd("FileType", {
  group = general,
  pattern = globals.text_filetypes,
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en"
    vim.opt_local.wrap = true
    vim.opt_local.textwidth = 0 -- no hard line breaks
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.showbreak = "󱞩 "
    vim.opt_local.formatoptions:remove("t") -- don't auto-wrap text
    vim.opt_local.formatoptions:remove("c") -- don't auto-wrap comments
  end,
})

----- Auto-generate spell files on startup if missing -----
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

----- Quit if only picker/explorer windows remain -----
local autoclose_filetypes = globals.autoclose_filetypes
autocmd("WinClosed", {
  group = general,
  callback = function()
    vim.schedule(function()
      local wins = vim.api.nvim_list_wins()
      local real_wins = vim.tbl_filter(function(win)
        if vim.api.nvim_win_get_config(win).zindex then
          return false
        end
        local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
        return not vim.tbl_contains(autoclose_filetypes, ft)
      end, wins)
      if #real_wins == 0 and #wins > 0 then
        vim.cmd("qa")
      end
    end)
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

----- Auto-format on save (respects vim.g.autoformat_enabled) -----
autocmd("BufWritePre", {
  group = general,
  desc = "Auto-format on save",
  callback = function()
    if vim.g.autoformat_enabled ~= false then
      vim.lsp.buf.format({ timeout_ms = 1000 })
    end
  end,
})
