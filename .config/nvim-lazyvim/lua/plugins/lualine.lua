return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_z = {
        function()
          return os.date("%-I:%M %p")
        end,
      }

      opts.sections.lualine_x = opts.sections.lualine_x or {}
      table.insert(opts.sections.lualine_x, 1, {
        function()
          if os.getenv("TMUX") then
            return ""
          else
            return ""
          end
        end,
        color = {
          fg = "#7AA87F",
          bg = nil,
          gui = "bold",
        },
      })
      return opts
    end,
  },
}
