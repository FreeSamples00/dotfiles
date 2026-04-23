--- Language System Plugin Configuration
---
--- Defines language configurations and plugin specs for:
--- - lang-system (local plugin with keybinds and commands)
--- - Mason (package manager)
--- - nvim-treesitter (syntax highlighting)
--- - nvim-lspconfig (LSP client)
--- - none-ls (formatters, linters)
---
--- Language definitions are passed to lang-system.setup() via lazy.nvim opts.

local lang_system = require("lang-system")

return {
  {
    "lang-system",
    dir = vim.fn.stdpath("config") .. "/lua/lang-system",
    name = "lang-system",
    main = "lang-system",
    lazy = false,
    priority = 100,
    keys = {
      { "<leader>dm", "<cmd>Mason<cr>", desc = "Mason UI" },
      { "<leader>dls", "<cmd>LanguageStatus<cr>", desc = "Status" },
      { "<leader>dll", "<cmd>LanguageList<cr>", desc = "List" },
      { "<leader>dli", "<cmd>LanguageInstallCurrent<cr>", desc = "Install Current" },
      { "<leader>dlu", "<cmd>LanguageUninstallCurrent<cr>", desc = "Uninstall Current" },
    },
    opts = {
      ensure_installed = { "nvim_core", "configs_group", "bash" },
      languages = {

        -- Language Categories

        nvim_core = {
          dependencies = {
            "regex",
            "lua",
            "vim",
          },
        },

        writing_group = {
          dependencies = {
            "markdown",
            "latex",
          },
        },

        configs_group = {
          dependencies = {
            "json",
            "toml",
            "yaml",
          },
        },

        -- Individual Language Defs

        regex = {
          treesitter = {
            "regex",
          },
        },

        lua = {
          filetypes = { "lua" },
          treesitter = "lua",
          lsp = {
            name = "lua_ls",
            config = {
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
            },
          },
          formatter = {
            name = "stylua",
          },
        },

        python = {
          filetypes = { "python", "py" },
          treesitter = "python",
          lsp = {
            name = "basedpyright",
          },
        },

        html = {
          filetypes = { "html" },
          treesitter = "html",
        },

        typescript = {
          filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "tsx", "jsx" },
          treesitter = { "typescript", "tsx", "javascript", "jsdoc" },
          dependencies = { "html" },
          lsp = {
            name = "ts_ls",
          },
          formatter = {
            name = "prettier",
            config = {
              filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "tsx", "jsx", "json" },
            },
          },
        },

        java = {
          filetypes = { "java" },
          treesitter = "java",
          lsp = {
            name = "jdtls",
          },
          formatter = {
            name = "google_java_format",
          },
        },

        markdown = {
          filetypes = { "markdown", "markdown.mdx", "md" },
          treesitter = { "markdown", "markdown_inline" },
          lsp = {
            name = "marksman",
          },
          formatter = {
            name = "prettier",
            config = {
              filetypes = { "markdown", "markdown.mdx" },
            },
          },
        },

        latex = {
          filetypes = { "latex", "tex", "bib" },
          treesitter = "latex",
          lsp = {
            name = "texlab",
          },
          formatter = {
            name = "tex-fmt",
          },
        },

        c = {
          filetypes = { "c" },
          treesitter = "c",
          lsp = {
            name = "clangd",
          },
          formatter = {
            name = "clang-format",
          },
        },

        cpp = {
          filetypes = { "cpp", "hpp", "cc" },
          treesitter = "cpp",
          lsp = {
            name = "clangd",
          },
          formatter = {
            name = "clang-format",
          },
        },

        go = {
          filetypes = { "go" },
          treesitter = "go",
          lsp = {
            name = "gopls",
          },
          formatter = {
            name = "gofumpt",
          },
        },

        rust = {
          filetypes = { "rust" },
          treesitter = "rust",
          lsp = {
            name = "rust_analyzer",
          },
          formatter = {
            name = "rustfmt",
            mason = false,
          },
        },

        vim = {
          filetypes = { "vim", "vimdoc" },
          treesitter = { "vim", "vimdoc" },
        },

        bash = {
          filetypes = { "sh", "bash", "zsh" },
          treesitter = "bash",
          lsp = {
            name = "bashls",
          },
          formatter = {
            name = "shfmt",
          },
          linter = {
            name = "shellcheck",
            enable = false,
            install = true,
          },
        },

        make = {
          filetypes = { "make", "makefile" },
          treesitter = "make",
        },

        nu = {
          filetypes = { "nu" },
          treesitter = "nu",
          lsp = {
            name = "nushell",
            mason = false,
          },
        },

        json = {
          filetypes = { "json", "jsonc" },
          treesitter = "json",
          lsp = {
            name = "jsonls",
          },
          formatter = {
            name = "prettier",
          },
        },

        yaml = {
          filetypes = { "yml", "yaml" },
          treesitter = "yaml",
          lsp = {
            name = "yamlls",
          },
          formatter = {
            name = "prettier",
          },
          linter = {
            name = "yamllint",
          },
        },

        toml = {
          filetypes = { "toml", "tml" },
          treesitter = "toml",
          lsp = {
            name = "tombi",
          },
        },

        just = {
          filetypes = { "just" },
          treesitter = "just",
          lsp = {
            name = "just-lsp",
          },
        },
      },
    },
  },

  {
    "williamboman/mason.nvim",
    lazy = false,
    dependencies = { "lang-system" },
    config = function()
      lang_system.setup_mason()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
    dependencies = {
      "lang-system",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      lang_system.setup_treesitter()
    end,
  },

  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "lang-system",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
      "RRethy/vim-illuminate",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      lang_system.setup_lspconfig()
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      lang_system.setup_null_ls()
    end,
  },
}
