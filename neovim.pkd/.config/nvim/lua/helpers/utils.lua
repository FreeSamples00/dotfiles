--- Utility functions and shared option tables used across plugin specs

local M = {}

--- Window options for wrapped text (used in snacks notifications, picker preview, help windows)
M.wrap_options = {
  wrap = true,
  breakindent = true,
  showbreak = "󱞩 ",
  linebreak = true,
  spell = false,
}

--- Truncate a file path by dropping middle segments
--- Used in snacks dashboard for cwd display
---@param path string Full path to truncate
---@param max_len? number Maximum output length (default 50)
---@param direction? "left"|"middle"|"right" Where to drop segments (default "middle")
---@param delim? string Truncation indicator (default "...")
---@return string Truncated path
function M.truncate_path(path, max_len, direction, delim)
  max_len = max_len or 50
  delim = "/" .. (delim or "...")
  local select = ({
    left = function()
      return 2
    end,
    middle = function(n)
      return math.ceil(n / 2)
    end,
    right = function(n)
      return n - 1
    end,
  })[direction or "middle"] or error("Bad direction: " .. direction)

  if #path <= max_len then
    return path
  end

  -- parse out dirnames
  local segments = {}
  local first = true
  for seg in path:gmatch("[^/]+") do
    if string.match(seg, "^[.+~]$") and first then
      segments[#segments + 1] = seg
    else
      segments[#segments + 1] = "/" .. seg
    end
    first = false
  end

  -- drop middle dirs
  local target
  while (#(table.concat(segments)) > max_len - #delim) and #segments > 2 do
    target = select(#segments)
    table.remove(segments, target)
  end
  table.insert(segments, target, delim)
  return table.concat(segments)
end

return M
