local M = {}

--- Dynamically require all .lua files in a module directory (skipping init.lua).
--- Files are loaded in filesystem order, which is not guaranteed to be sorted.
--- When merging results with vim.tbl_deep_extend("force", ...), sub-modules must
--- write to distinct key paths — otherwise the last file loaded wins silently.
function M.require_all(mod)
  local dir = vim.fn.stdpath("config") .. "/lua/" .. mod:gsub("%.", "/")
  return vim
    .iter(vim.fn.readdir(dir))
    :filter(function(f)
      return f:match("%.lua$") and f ~= "init.lua"
    end)
    :map(function(f)
      return require(mod .. "." .. f:gsub("%.lua$", ""))
    end)
    :totable()
end

return M
