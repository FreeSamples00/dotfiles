--- mini.pairs: auto-pairing for brackets and quotes
--- Brackets: only pair when space/EOL follows cursor (prevents `(bar` -> `()bar`)
--- Quotes: custom keymap — close normally inside pairs, only open new pairs in whitespace contexts

local function quote_pair(char)
  return function()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local before = col > 0 and line:sub(col, col) or "\r"
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

    -- Open: only if space/line-start before AND space/EOL after
    if (before == " " or before == "\r") and (after_char == " " or after_char == "\n") then
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
    skip_ts = { "string" }, -- skip inside treesitter strings
    skip_unbalanced = true,
    markdown = true,
    mappings = {
      -- Brackets: pair only when space/EOL follows cursor (any char before is ok)
      ["("] = { action = "open", pair = "()", neigh_pattern = ".[ \n]", register = { cr = false } },
      ["["] = { action = "open", pair = "[]", neigh_pattern = ".[ \n]", register = { cr = false } },
      ["{"] = { action = "open", pair = "{}", neigh_pattern = ".[ \n]", register = { cr = false } },
      -- Quotes: overridden by custom keymaps in config function below
      ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^%w\\].", register = { cr = false } },
      ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%w\\].", register = { cr = false } },
      ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^%w\\].", register = { cr = false } },
    },
  },
  config = function(_, opts)
    require("mini.pairs").setup(opts)
    -- Custom quote keymaps: close inside pairs, only open in whitespace contexts
    for _, char in ipairs({ '"', "'", "`" }) do
      vim.keymap.set("i", char, quote_pair(char), { expr = true, replace_keycodes = true })
    end
  end,
}
