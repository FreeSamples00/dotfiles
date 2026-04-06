-- aggregator for core config files

local core_dir = vim.fn.stdpath("config") .. "/lua/core"

for _, file in ipairs(vim.fn.glob(core_dir .. "/*.lua", false, true)) do
  local name = vim.fn.fnamemodify(file, ":t:r")
  if name ~= "init" and name ~= "lazy" then
    require("core." .. name)
  end
end
