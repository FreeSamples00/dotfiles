local languages = require("core.languages")

return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()

      vim.defer_fn(function()
        languages.install_ensure_installed()
      end, 100)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = languages.get_ensure_installed_parsers(),
        highlight = { enable = true },
        indent = { enable = true, disable = { "python" } },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-s>",
            node_decremental = "<c-backspace>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
      "RRethy/vim-illuminate",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local globals = require("helpers.globals")

      require("neodev").setup()

      vim.diagnostic.config({
        virtual_text = false,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = globals.lsp_icons.error,
            [vim.diagnostic.severity.WARN] = globals.lsp_icons.warn,
            [vim.diagnostic.severity.INFO] = globals.lsp_icons.info,
            [vim.diagnostic.severity.HINT] = globals.lsp_icons.hint,
          },
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      local on_attach = function(client, bufnr)
        local lsp_map = require("helpers.keys").lsp_map

        local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
        local lang_name, lang = languages.get_language_for_filetype(ft)
        if lang and lang.formatter and lang.formatter.enabled then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end

        lsp_map("J", vim.diagnostic.open_float, bufnr, "LSP Diagnostics")
        lsp_map("K", vim.lsp.buf.hover, bufnr, "LSP Hover")
        lsp_map("<leader>la", vim.lsp.buf.code_action, bufnr, "Code Action")
        lsp_map("<leader>lh", Snacks.picker.diagnostics_buffer, bufnr, "Buffer Diagnostics")
        lsp_map("<leader>lH", Snacks.picker.diagnostics, bufnr, "All Diagnostics")
        lsp_map("<leader>lk", "<cmd>lua vim.lsp.buf.signature_help()<cr>", bufnr, "Show Signature")
        lsp_map("<leader>lt", Snacks.picker.lsp_type_definitions, bufnr, "Type Definition")
        lsp_map("<leader>lr", Snacks.picker.lsp_references, bufnr, "References")
        lsp_map("<leader>lR", vim.lsp.buf.rename, bufnr, "Rename Symbol")
        lsp_map("<leader>ld", Snacks.picker.lsp_definitions, bufnr, "Definition")
        lsp_map("<leader>lD", Snacks.picker.lsp_declarations, bufnr, "Declaration")
        lsp_map("<leader>li", Snacks.picker.lsp_implementations, bufnr, "Implementation")
        lsp_map("<leader>lc", Snacks.picker.lsp_incoming_calls, bufnr, "Incoming Calls")
        lsp_map("<leader>lC", Snacks.picker.lsp_outgoing_calls, bufnr, "Outgoing Calls")
        lsp_map("<leader>ls", Snacks.picker.lsp_symbols, bufnr, "Buffer Symbols")
        lsp_map("<leader>lS", Snacks.picker.lsp_workspace_symbols, bufnr, "All Symbols")

        vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
          vim.lsp.buf.format()
        end, { desc = "Format current buffer with LSP" })

        lsp_map("<leader>uf", "<cmd>AutoFormatToggle<cr>", bufnr, "Toggle auto-format")
        lsp_map("<leader>ff", "<cmd>Format<cr>", bufnr, "Format")

        require("illuminate").on_attach(client)
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      for lang_name, lang in pairs(languages.languages) do
        if lang.lsp and lang.lsp.enabled then
          local config = vim.tbl_deep_extend("force", {
            on_attach = on_attach,
            capabilities = capabilities,
          }, lang.lsp.config or {})

          vim.lsp.config(lang.lsp.name, config)
        end
      end

      require("mason-lspconfig").setup({
        ensure_installed = languages.get_ensure_installed_lsp_servers(),
        automatic_installation = true,
        automatic_enable = true,
      })

      vim.api.nvim_create_user_command("AutoFormatToggle", function()
        vim.g.autoformat_enabled = not vim.g.autoformat_enabled
        vim.notify(
          string.format("Auto-formatting %s", vim.g.autoformat_enabled and "enabled" or "disabled"),
          vim.log.levels.INFO
        )
      end, { desc = "Toggle auto-formatting on save" })

      require("helpers.keys").map("n", "<leader>M", "<cmd>Mason<cr>", "Mason.nvim")

      vim.api.nvim_create_user_command("LanguageInstall", function(opts)
        local lang_name = opts.args
        if lang_name == "" then
          local lang_names = vim.tbl_keys(languages.languages)
          vim.ui.select(lang_names, {
            prompt = "Select language to install:",
          }, function(choice)
            if choice then
              languages.install_language(choice)
            end
          end)
        else
          languages.install_language(lang_name)
        end
      end, {
        nargs = "?",
        complete = function()
          return vim.tbl_keys(languages.languages)
        end,
        desc = "Install language tools",
      })

      vim.api.nvim_create_user_command("LanguageUninstall", function(opts)
        local lang_name = opts.args
        if lang_name == "" then
          local lang_names = vim.tbl_keys(languages.languages)
          vim.ui.select(lang_names, {
            prompt = "Select language to uninstall:",
          }, function(choice)
            if choice then
              languages.uninstall_language(choice)
            end
          end)
        else
          languages.uninstall_language(lang_name)
        end
      end, {
        nargs = "?",
        complete = function()
          return vim.tbl_keys(languages.languages)
        end,
        desc = "Uninstall language tools",
      })

      vim.api.nvim_create_user_command("LanguageList", function()
        local lang_names = vim.tbl_keys(languages.languages)
        table.sort(lang_names)
        vim.notify("Defined languages:\n" .. table.concat(lang_names, "\n"), vim.log.levels.INFO)
      end, { desc = "List all defined languages" })

      vim.api.nvim_create_user_command("LanguageStatus", function()
        local status = languages.status()
        local lines = { "Language Status:", "" }
        local sorted = {}
        for lang_name, lang_status in pairs(status) do
          if lang_status then
            table.insert(sorted, { name = lang_name, status = lang_status })
          end
        end
        table.sort(sorted, function(a, b)
          return a.name < b.name
        end)
        for _, item in ipairs(sorted) do
          local status_str = item.status.complete and "✓" or "○"
          table.insert(lines, string.format("  %s %s", status_str, item.name))
        end
        vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
      end, { desc = "Show language installation status" })
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      local sources = {}
      local formatters_by_name = {}

      for lang_name, formatter in pairs(languages.get_all_formatters()) do
        local name = formatter.name
        if not formatters_by_name[name] then
          formatters_by_name[name] = { config = formatter.config }
        elseif formatter.config and formatter.config.filetypes then
          local existing = formatters_by_name[name]
          if existing.config and existing.config.filetypes then
            for _, ft in ipairs(formatter.config.filetypes) do
              if not vim.tbl_contains(existing.config.filetypes, ft) then
                table.insert(existing.config.filetypes, ft)
              end
            end
          end
        end
      end

      for name, formatter_data in pairs(formatters_by_name) do
        local builtin = null_ls.builtins.formatting[name]
        if builtin then
          if formatter_data.config then
            builtin = builtin.with(formatter_data.config)
          end
          table.insert(sources, builtin)
        end
      end

      for lang_name, linter in pairs(languages.get_all_linters()) do
        local builtin = null_ls.builtins.diagnostics[linter.name]
        if builtin then
          if linter.config then
            builtin = builtin.with(linter.config)
          end
          table.insert(sources, builtin)
        end
      end

      null_ls.setup({ sources = sources })
    end,
  },
}
