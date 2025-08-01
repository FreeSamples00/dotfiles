return {
  "nanozuki/tabby.nvim", -- The plugin's name/path for LazyVim to install
  enable = true,
  event = "VimEnter", -- Example: load on Vim startup. Choose an appropriate event.
  -- or `cmd = "TabbyToggle"`, or `ft = "lua"`, etc., for lazy loading.
  config = function()
    -- All your setup code goes here, inside this function
    local theme = {
      fill = "TabLineFill",
      head = "TabLine",
      current_tab = "TabLineSel",
      tab = "TabLine",
      win = "TabLine",
      tail = "TabLine",
    }

    vim.opt.showtabline = 2

    require("tabby").setup({
      line = function(line)
        return {
          {
            { "  ", hl = theme.head },
            -- line.sep("", theme.head, theme.fill),
            line.sep("", theme.head, theme.fill),
          },
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            return {
              line.sep("", hl, theme.fill),
              tab.is_current() and "" or "",
              tab.number(),
              tab.name(),
              tab.close_btn(""),
              line.sep("", hl, theme.fill),
              hl = hl,
              margin = " ",
            }
          end),
          line.spacer(),
          line.bufs().foreach(function(buf)
            local buf_hl = theme.win -- Using the same highlight group as windows
            return {
              line.sep("", buf_hl, theme.fill),
              --  for current buffer in focused window,  for others
              buf.is_current() and "" or "",
              buf.name(), -- Use buf.name() for the buffer name
              line.sep("", buf_hl, theme.fill),
              hl = buf_hl,
              margin = " ",
            }
          end),
          {
            line.sep("", theme.tail, theme.fill),
            { "  ", hl = theme.tail },
          },
          hl = theme.fill,
        }
      end,
      -- option = {}, -- setup modules' option,
    })
  end,
}
