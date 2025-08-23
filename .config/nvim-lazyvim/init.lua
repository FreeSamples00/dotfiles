-- bootstrap lazy.nvim, LazyVim and your plugins

--NOTE: percentage of screen from top or bottom and which autoscrolling is triggered
-- - use 50 for typewriter style
local TRIGGER_PERCENTAGE = 40

local function set_dynamic_scrolloff()
  local h = vim.api.nvim_win_get_height(0)
  vim.wo.scrolloff = math.max(1, math.floor(h * (TRIGGER_PERCENTAGE / 100)))
end

local grp = vim.api.nvim_create_augroup("DynamicScrolloff", { clear = true })
vim.api.nvim_create_autocmd({ "VimResized", "WinResized", "BufWinEnter", "WinEnter" }, {
  group = grp,
  callback = set_dynamic_scrolloff,
})

require("config.lazy")
