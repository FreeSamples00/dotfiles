-- LSP Configuration & Plugins

local globals = require("helpers.globals")

return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
      "RRethy/vim-illuminate",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Set up Mason before anything else
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pylsp",
          "marksman",
        },
        automatic_installation = true,
      })

      -- Quick access via keymap
      require("helpers.keys").map("n", "<leader>M", "<cmd>Mason<cr>", "Show Mason")

      -- Neodev setup before LSP config
      require("neodev").setup()

      -- Diagnostic config
      local config = {
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
      }
      vim.diagnostic.config(config)

      -- This function gets run when an LSP connects to a particular buffer.
      local on_attach = function(client, bufnr)
        local lsp_map = require("helpers.keys").lsp_map

        lsp_map("J", vim.diagnostic.open_float, bufnr, "LSP Diagnostics")
        lsp_map("K", vim.lsp.buf.hover, bufnr, "LSP Hover")

        lsp_map("<leader>la", vim.lsp.buf.code_action, bufnr, "Code Action")
        lsp_map("<leader>lh", Snacks.picker.diagnostics_buffer, bufnr, "Buffer Diagnostics")
        lsp_map("<leader>lH", Snacks.picker.diagnostics, bufnr, "All Diagnostics")
        lsp_map("<leader>lk", "<cmd>Noice signature<cr>", bufnr, "Show Signature")
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

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
          vim.lsp.buf.format()
        end, { desc = "Format current buffer with LSP" })

        lsp_map("<leader>uf", "<cmd>AutoFormatToggle<cr>", bufnr, "Toggle auto-format")
        lsp_map("<leader>ff", "<cmd>Format<cr>", bufnr, "Format")

        -- Attach and configure vim-illuminate
        require("illuminate").on_attach(client)
      end

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      -- Lua
      vim.lsp.config("lua_ls", {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
          },
        },
      })
      vim.lsp.enable("lua_ls")

      -- Python
      vim.lsp.config("pylsp", {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          pylsp = {
            plugins = {
              flake8 = {
                enabled = true,
                maxLineLength = 88, -- Black's line length
              },
              -- Disable plugins overlapping with flake8
              pycodestyle = {
                enabled = false,
              },
              mccabe = {
                enabled = false,
              },
              pyflakes = {
                enabled = false,
              },
              -- Use Black as the formatter
              autopep8 = {
                enabled = false,
              },
            },
          },
        },
      })
      vim.lsp.enable("pylsp")

      -- Nushell (official LSP server built into nushell v0.111.0+)
      vim.lsp.config("nushell", {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable("nushell")

      -- Marksman (Markdown LSP server)
      vim.lsp.config("marksman", {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable("marksman")

      -- Auto-format toggle command
      vim.api.nvim_create_user_command("AutoFormatToggle", function()
        vim.g.autoformat_enabled = not vim.g.autoformat_enabled
        vim.notify(
          string.format("Auto-formatting %s", vim.g.autoformat_enabled and "enabled" or "disabled"),
          vim.log.levels.INFO
        )
      end, { desc = "Toggle auto-formatting on save" })
    end,
  },
}
