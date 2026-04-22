--- Language Configuration - Declarative Tool Definitions
---
--- This is the single source of truth for language tooling.
--- Define languages here, and the rest of the system reads from it.
---
--- Tool Schema:
---   filetypes: string[] - Filetypes this language handles
---   treesitter: string|string[] - Parser name(s) for treesitter
---   lsp: { name: string, config?: table, mason?: boolean }
---   formatter: { name: string, config?: table, mason?: boolean }
---   linter: { name: string, config?: table, mason?: boolean, enable?: boolean }
---   dap: { name: string, config?: table, mason?: boolean, enable?: boolean }
---
--- Tool defaults (applied by languages.lua):
---   enable: true (if not specified)
---   install: true (if not specified)
---   mason: true (if not specified) - set false for system-installed tools

local M = {}

--- Languages to install on startup. Add language names from M.languages.
M.ensure_installed = { "utility", "lua", "markdown", "vim", "json", "toml", "yaml", "bash" }

--- Language definitions. Key is the language name used in commands.
M.languages = {

  utility = {
    treesitter = {
      "regex", -- needed by snacks
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
      name = "pylsp",
      config = {
        settings = {
          pylsp = {
            plugins = {
              flake8 = {
                enabled = true,
                maxLineLength = 88,
              },
              pycodestyle = {
                enabled = false,
              },
              mccabe = {
                enabled = false,
              },
              pyflakes = {
                enabled = false,
              },
              autopep8 = {
                enabled = false,
              },
            },
          },
        },
      },
    },
    formatter = {
      name = "black",
    },
    linter = {
      name = "ruff",
    },
  },

  typescript = {
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "tsx", "jsx" },
    treesitter = { "typescript", "tsx", "javascript", "jsdoc" },
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

  vimdoc = {
    filetypes = { "vimdoc" },
    treesitter = "vimdoc",
  },

  vim = {
    filetypes = { "vim" },
    treesitter = "vim",
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
}

return M
