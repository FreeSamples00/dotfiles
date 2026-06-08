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

----- Open dashboard when last buffer is deleted -----
autocmd("BufDelete", {
  group = general,
  callback = function(args)
    -- Bail if the deleted buffer was a dashboard (user intentionally closed it)
    local deleted_ft = vim.api.nvim_buf_is_valid(args.buf) and vim.bo[args.buf].filetype or ""
    if deleted_ft == "snacks_dashboard" then
      return
    end

    vim.schedule(function()
      -- Skip if a dashboard already exists in any window
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "snacks_dashboard" then
          return
        end
      end

      -- Check if any loaded, listed, named buffers remain
      local has_real_buffer = false
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
          local name = vim.api.nvim_buf_get_name(buf)
          local ft = vim.bo[buf].filetype
          -- "Real" = has a filename and isn't the dashboard
          if name ~= "" and ft ~= "snacks_dashboard" then
            has_real_buffer = true
            break
          end
        end
      end

      if not has_real_buffer then
        -- Find a non-floating window that isn't showing special content
        -- Avoids overriding help floats and other special windows
        local target_win
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local cfg = vim.api.nvim_win_get_config(win)
          if cfg.relative == "" then -- non-floating
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            if ft ~= "help" and ft ~= "man" and ft ~= "snacks_dashboard" then
              target_win = win
              break
            end
          end
        end

        if target_win then
          Snacks.dashboard.open({ win = target_win })
        end
      end
    end)
  end,
})

----- Image viewer buffers are render-only (snacks.image), never write -----
autocmd("FileType", {
  group = general,
  pattern = "image",
  callback = function()
    vim.bo.buftype = "nowrite"
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
