-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Enable spell checking
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "markdown", "tex", "quarto" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en"
  end,
})

-- Enable word wrapping
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "markdown", "tex", "quarto" },
  callback = function()
    vim.opt_local.wrap = true
  end,
})

-- Auto generate spell files as needed
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local config_path = vim.fn.stdpath("config")
    local spell_dir = config_path .. "/spell"

    -- Check if spell directory exists
    if vim.fn.isdirectory(spell_dir) == 0 then
      return
    end

    -- Find all .add files in spell directory
    local add_files = vim.fn.glob(spell_dir .. "/*.add", false, true)

    for _, add_file in ipairs(add_files) do
      local spl_file = add_file .. ".spl"

      -- If .spl doesn't exist, compile it
      if vim.fn.filereadable(spl_file) == 0 then
        vim.cmd.mkspell({ add_file, bang = false })
      end
    end
  end,
})
