-- https://github.com/folke/snacks.nvim

local hidden_search_options = {
  layout = { hidden = { "input" } },
  auto_confirm = false,
}

local wrap_options = {
  wrap = true,
  breakindent = true,
  showbreak = "󱞩 ",
  linebreak = true,
  spell = false,
}

local truncate_path = require("helpers.utils").truncate_path

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    image = { enabled = true, doc = { inline = false, float = false } },
    animate = { enable = true },
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { key = "q", action = ":qa", hidden = true },
        },
      },
      sections = {
        { section = "header", padding = 1 },
        function()
          local stats = require("lazy.stats").stats()
          local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
          return {
            align = "center",
            text = {
              { "💤 ", hl = "" },
              { "Loaded ", hl = "keyword" },
              { stats.loaded .. "/" .. stats.count, hl = "special" },
              { " plugins in ", hl = "keyword" },
              { ms .. "ms", hl = "special" },
            },
            padding = 0,
          }
        end,
        function()
          local ok, Checker = pcall(require, "lazy.manage.checker")
          if not ok then
            return { padding = 0 }
          end
          Checker.fast_check({ report = false })
          local updates = #Checker.updated
          if updates == 0 then
            return { padding = 0 }
          end
          return {
            align = "center",
            text = {
              { "📦 ", hl = "keyword" },
              { tostring(updates), hl = "special" },
              { " ", hl = "keyword" },
              { "Updates available", hl = "keyword" },
            },
            padding = 1,
          }
        end,
        {
          title = " " .. truncate_path(vim.fn.fnamemodify(vim.fn.getcwd(), ":~"), 45),
          padding = 1,
          align = "center",
        },
        { section = "keys", gap = 1, padding = 0 },
      },
    },
    explorer = { enabled = true },
    indent = {
      enabled = true,
      chunk = {
        enabled = true,
      },
    },
    input = { enabled = true },
    notifier = { enabled = true },
    picker = {
      enabled = true,
      sources = {
        buffers = {
          layout = { hidden = { "input" } },
          win = {
            list = {
              keys = {
                ["l"] = "confirm",
              },
            },
          },
        },
        notifications = {
          layout = { hidden = { "input" } },
          win = {
            preview = {
              wo = wrap_options,
            },
          },
        },
        todo_comments = {
          layout = { hidden = { "input" } },
        },
        marks = {
          layout = { hidden = { "input" } },
        },
        keymaps = {
          confirm = function(picker, item)
            picker:norm(function()
              if item then
                picker:close()
                if item.file and item.pos then
                  vim.cmd("edit " .. vim.fn.fnameescape(item.file))
                  vim.api.nvim_win_set_cursor(0, { item.pos[1], item.pos[2] })
                elseif item.file then
                  vim.cmd("edit " .. vim.fn.fnameescape(item.file))
                else
                  vim.notify("No file location available for this keymap", vim.log.levels.WARN)
                end
              end
            end)
          end,
        },
        undo = {
          layout = {
            hidden = { "input" },
            layout = {
              width = 0.9,
              height = 0.9,
              min_width = 100,
              min_height = 30,
              box = "horizontal",
              {
                box = "vertical",
                width = 42,
                { win = "input", height = 0 },
                { win = "list", height = 0 },
              },
              { win = "preview", width = 0 },
            },
          },
          win = {
            input = { border = "rounded" },
            list = { border = "rounded" },
            preview = { border = "rounded" },
          },
        },
        lsp_definitions = hidden_search_options,
        lsp_declarations = hidden_search_options,
        lsp_references = hidden_search_options,
        lsp_implementations = hidden_search_options,
        lsp_type_definitions = hidden_search_options,
        lsp_incoming_calls = hidden_search_options,
        lsp_outgoing_calls = hidden_search_options,
        lsp_symbols = hidden_search_options,
        lsp_workspaces_symbols = hidden_search_options,
        diagnostics_buffer = hidden_search_options,
        diagnostics = hidden_search_options,
        git_log = hidden_search_options,
        git_files = hidden_search_options,
        git_branches = hidden_search_options,
        git_log_line = hidden_search_options,
        git_log_file = hidden_search_options,
        git_diff = hidden_search_options,
        explorer = {
          layout = {
            preset = "sidebar",
            preview = "main",
            -- hidden = { "preview" }, -- hide preview by default
          },
          win = {
            preview = {
              col = 0,
              row = 0,
              max_width = 50,
              max_height = 35,
              border = "rounded",
            },
          },
        },
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        wo = wrap_options,
        width = { min = 20, max = 60 },
        height = { min = 1, max = 10 },
      },
    },
  },
  keys = {
    -- Top Pickers & Explorer
    {
      "<leader><space>",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart Find Files",
    },
    {
      "L",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
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
        Snacks.explorer()
      end,
      desc = "File Explorer",
    },
    -- find
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
      "<leader>sf",
      function()
        Snacks.picker.files()
      end,
      desc = "Files",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.git_files()
      end,
      desc = "Find Git Files",
    },
    {
      "<leader>sr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent Files",
    },
    -- git
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
    -- search
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
    -- Other
    {
      "<leader>fr",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename",
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
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
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
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end

        -- Override print to use snacks for `:=` command
        if vim.fn.has("nvim-0.11") == 1 then
          vim._print = function(_, ...)
            dd(...)
          end
        else
          vim.print = _G.dd
        end

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.option("colorcolumn", { name = "Color Column", off = "", on = "80" }):map("<leader>uv")
        Snacks.toggle
          .new({
            name = "Auto Format",
            get = function()
              return vim.g.autoformat_enabled ~= false
            end,
            set = function(state)
              vim.g.autoformat_enabled = state
            end,
          })
          :map("<leader>uf")
        Snacks.toggle
          .new({
            name = "Inline Images",
            get = function()
              return Snacks.image.config.doc.inline
            end,
            set = function(state)
              Snacks.image.config.doc.inline = state
              local langs = Snacks.image.langs()
              for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(buf) then
                  local ft = vim.bo[buf].filetype
                  if vim.tbl_contains(langs, ft) then
                    Snacks.image.placement.clean(buf)
                    pcall(vim.api.nvim_del_augroup_by_name, "snacks.image.inline." .. buf)
                    vim.b[buf].snacks_image_attached = nil
                    if state then
                      Snacks.image.doc.attach(buf)
                    end
                  end
                end
              end
            end,
          })
          :map("<leader>ui")
        Snacks.toggle
          .new({
            name = "Colorizer",
            get = function()
              return vim.b.colorizer_enabled ~= false
            end,
            set = function(state)
              vim.b.colorizer_enabled = state
              if state then
                require("colorizer").attach_to_buffer(0)
              else
                require("colorizer").detach_from_buffer(0)
              end
            end,
          })
          :map("<leader>uc")
      end,
    })

    -- Open help buffers in floating window
    vim.api.nvim_create_autocmd("BufWinEnter", {
      pattern = "*.txt",
      callback = function()
        if vim.bo.filetype == "help" then
          local win = vim.api.nvim_get_current_win()
          local cfg = vim.api.nvim_win_get_config(win)
          if cfg.relative == "" then
            local buf = vim.api.nvim_get_current_buf()
            vim.api.nvim_win_close(win, false)
            Snacks.win({
              buf = buf,
              border = "rounded",
              title = " Help ",
              width = 0.9,
              height = 0.8,
              wo = {
                spell = false,
                wrap = true,
                breakindent = true,
                showbreak = "󱞩 ",
                linebreak = true,
                signcolumn = "yes",
                statuscolumn = " ",
                conceallevel = 3,
              },
            })
          end
        end
      end,
    })
  end,
}
