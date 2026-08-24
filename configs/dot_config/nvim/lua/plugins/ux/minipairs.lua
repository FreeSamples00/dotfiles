--- mini.pairs: auto-pairing for brackets and quotes
--- Brackets: pair when non-word, non-quote char follows cursor (prevents `(bar` -> `()bar`)
--- Quotes: custom keymap — close normally inside pairs, only open new pairs in safe contexts

local function in_ts_string()
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then
    return false
  end
  return node:type():match("string") ~= nil
end

local function quote_pair(char)
  return function()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local after_char = line:sub(col + 1, col + 1)
    if after_char == "" then
      after_char = "\n"
    end

    -- Close: if unmatched open quote exists and closing char is right after cursor
    local count_before = 0
    for i = 1, col do
      if line:sub(i, i) == char then
        count_before = count_before + 1
      end
    end
    if count_before % 2 == 1 and after_char == char then
      return "<Right>"
    end

    -- Guard: don't open a new pair when there's an unmatched quote before cursor
    -- (prevents "foo" → "foo"" at end of strings)
    if count_before % 2 == 1 then
      return char
    end

    -- Guard: don't open a new pair inside a treesitter string node
    -- (catches escaped quotes that the count heuristic misses)
    if in_ts_string() then
      return char
    end

    -- Don't open a new pair when extending a run of the same quote
    -- (e.g., markdown ``` fence shouldn't become ````)
    local before_char = line:sub(col, col)
    if before_char == char then
      return char
    end

    -- Open: when char after cursor is safe (not word, not same quote, not backslash)
    if not after_char:match("[%w\\]") and after_char ~= char then
      return char .. char .. "<Left>"
    end

    -- Otherwise: insert literal char
    return char
  end
end

return {
  "nvim-mini/mini.pairs",
  event = "VeryLazy",
  opts = {
    modes = { insert = true, command = true, terminal = false },
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=], -- skip pairing after word chars
    skip_unbalanced = true,
    mappings = {
      -- Brackets: pair when non-word, non-quote char follows cursor (any char before is ok)
      ["("] = { action = "open", pair = "()", neigh_pattern = ".[^%w_\"'`]", register = { cr = false } },
      ["["] = { action = "open", pair = "[]", neigh_pattern = ".[^%w_\"'`]", register = { cr = false } },
      ["{"] = { action = "open", pair = "{}", neigh_pattern = ".[^%w_\"'`]", register = { cr = false } },
      -- Quotes: overridden by custom keymaps in config function below
      ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^%w\\].", register = { cr = false } },
      ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%w\\].", register = { cr = false } },
      ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^%w\\].", register = { cr = false } },
    },
  },
  config = function(_, opts)
    require("mini.pairs").setup(opts)
    -- Custom quote keymaps: close inside pairs, only open in safe contexts
    for _, char in ipairs({ '"', "'", "`" }) do
      vim.keymap.set("i", char, quote_pair(char), { expr = true, replace_keycodes = true })
    end
  end,
}
