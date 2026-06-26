--- Snacks keymaps: picker shortcuts, git, explorer, toggle mappings, debug helpers

return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader><space>",
      function()
        Snacks.picker.files()
      end,
      desc = "Find files",
    },
    {
      "L",
      function()
        -- Close explorer if open (mutual exclusivity)
        for _, p in ipairs(Snacks.picker.get({ source = "explorer" })) do
          p:close()
        end
        -- Defer open: explorer cleanup is scheduled in p:close(),
        -- so we queue after it to avoid window event races
        vim.schedule(function()
          Snacks.picker.buffers({
            layout = { preset = "sidebar", preview = "main", hidden = {} }, -- show input bar with title/chrome
            auto_close = false, -- stay open when focusing main window
            jump = { close = false }, -- stay open after selecting a buffer
            focus = "list", -- start in list; press / or a to focus search
            win = {
              list = {
                keys = {
                  ["a"] = "focus_input", -- press a to jump to search bar
                },
              },
            },
            on_show = function(picker)
              -- Refresh on buffer add/delete/wipe so the list stays live.
              -- Events are scoped to the picker's list window augroup,
              -- so they're cleaned up automatically when the picker closes.
              picker.list.win:on({ "BufAdd", "BufDelete", "BufWipeout" }, function()
                if not picker.closed then
                  vim.schedule(function()
                    if not picker.closed then
                      picker:find()
                    end
                  end)
                end
              end)
            end,
          })
        end)
      end,
      desc = "Buffers (sidebar)",
    },
    {
      "<leader>/",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep",
    },
    {
      "<leader>:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader>n",
      function()
        Snacks.picker.notifications()
      end,
      desc = "Notifications",
    },
    {
      "<leader>e",
      function()
        -- Close buffer sidebar if open (mutual exclusivity)
        for _, p in ipairs(Snacks.picker.get({ source = "buffers" })) do
          p:close()
        end
        -- Defer open: buffer sidebar cleanup is scheduled in p:close(),
        -- so we queue after it to avoid window event races
        vim.schedule(function()
          Snacks.explorer()
        end)
      end,
      desc = "File Explorer",
    },

    -- file group
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>fc",
      function()
        Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Find Config File",
    },
    {
      "<leader>ss",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart Search",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.git_files()
      end,
      desc = "Find Git Files",
    },
    {
      "<leader>fr",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename",
    },
    -- git group
    {
      "<leader>gb",
      function()
        Snacks.picker.git_branches()
      end,
      desc = "Git Branches",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log()
      end,
      desc = "Git Log",
    },
    {
      "<leader>gd",
      function()
        Snacks.picker.git_diff()
      end,
      desc = "Git Diff",
    },
    {
      "<leader>gL",
      function()
        Snacks.picker.git_log_line()
      end,
      desc = "Git Log Line",
    },
    {
      "<leader>gf",
      function()
        Snacks.picker.git_log_file()
      end,
      desc = "Git Log File",
    },
    {
      "<leader>gB",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
      mode = { "n", "v" },
    },
    {
      "<leader>gg",
      function()
        Snacks.lazygit({
          args = {
            "--screen-mode",
            "half",
          },
        })
      end,
      desc = "Lazygit",
    },

    -- search group
    {
      "<leader>r",
      function()
        Snacks.picker.registers()
      end,
      desc = "Registers",
    },
    {
      "<leader>sb",
      function()
        Snacks.picker.lines()
      end,
      desc = "Buffer Lines",
    },
    {
      "<leader>sc",
      function()
        Snacks.picker.commands()
      end,
      desc = "Commands",
    },
    {
      "<leader>sh",
      function()
        Snacks.picker.help()
      end,
      desc = "Help Pages",
    },
    {
      "<leader>si",
      function()
        Snacks.picker.icons()
      end,
      desc = "Icons",
    },
    {
      "<leader>sk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Keymaps",
    },
    {
      "<leader>sm",
      function()
        Snacks.picker.marks()
      end,
      desc = "Marks",
    },
    {
      "<leader>m",
      function()
        Snacks.picker.marks()
      end,
      desc = "Marks",
    },
    {
      "<leader>U",
      function()
        Snacks.picker.undo()
      end,
      desc = "Undo History",
    },
    {
      "<leader>su",
      function()
        Snacks.picker.undo()
      end,
      desc = "Undo History",
    },
    {
      "<leader>uC",
      function()
        Snacks.picker.colorschemes()
      end,
      desc = "Colorschemes",
    },

    -- other
    {
      "<leader>i",
      function()
        Snacks.image.hover()
      end,
      desc = "Image Hover",
    },
    {
      "]]",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next Reference",
      mode = { "n", "t" },
    },
    {
      "[[",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Prev Reference",
      mode = { "n", "t" },
    },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          border = "rounded",
          title = " Neovim News ",
          title_pos = "center",
          width = 0.9,
          height = 0.7,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    },
  },
}
