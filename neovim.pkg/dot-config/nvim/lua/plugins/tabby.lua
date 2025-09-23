return {
  "nanozuki/tabby.nvim",
  enable = true,
  event = "VimEnter",
  config = function()
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
            { "  ", hl = theme.head },
            line.sep("", theme.head, theme.fill),
          },
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            return {
              line.sep("", hl, theme.fill),
              tab.is_current() and "" or "",
              tab.number(),
              (function()
                local tab_name = tab.name()
                local bad_prefix = "[Floating]"
                if string.sub(tab_name, 1, #bad_prefix) == bad_prefix then
                  return ""
                else
                  return tab_name
                end
              end)(),
              tab.close_btn(""),
              line.sep("", hl, theme.fill),
              hl = hl,
              margin = " ",
            }
          end),
          line.spacer(),
          line.bufs().foreach(function(buf)
            local buf_hl = theme.win
            return {
              line.sep("", buf_hl, theme.fill),
              buf.is_current() and "" or "",
              buf.name(),
              line.sep("", buf_hl, theme.fill),
              hl = buf_hl,
              margin = " ",
            }
          end),
          {
            line.sep("", theme.tail, theme.fill),
            { "  ", hl = theme.tail },
          },
          hl = theme.fill,
        }
      end,
    })
  end,
}
