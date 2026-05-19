local M = {}

M.wrap_options = {
  wrap = true,
  breakindent = true,
  showbreak = "󱞩 ",
  linebreak = true,
  spell = false,
}

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
