local M = {}

M.ensure_installed = { "lua", "markdown", "vim", "json", "toml", "yaml", "bash" }

M.languages = {
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
    linter = nil,
    dap = nil,
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
    linter = nil,
    dap = {
      name = "debugpy",
      enable = false,
      install = false,
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
    linter = nil,
    dap = nil,
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
    linter = nil,
    dap = nil,
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
    linter = nil,
    dap = nil,
  },

  latex = {
    filetypes = { "latex", "tex", "bib" },
    treesitter = "latex",
    lsp = {
      name = "texlab",
    },
    formatter = nil,
    linter = nil,
    dap = nil,
  },

  c = {
    filetypes = { "c" },
    treesitter = "c",
    lsp = nil,
    formatter = nil,
    linter = nil,
    dap = nil,
  },

  cpp = {
    filetypes = { "cpp", "hpp", "cc" },
    treesitter = "cpp",
    lsp = nil,
    formatter = nil,
    linter = nil,
    dap = nil,
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
    linter = nil,
    dap = nil,
  },

  rust = {
    filetypes = { "rust" },
    treesitter = "rust",
    lsp = nil,
    formatter = nil,
    linter = nil,
    dap = nil,
  },

  vimdoc = {
    filetypes = { "vimdoc" },
    treesitter = "vimdoc",
    lsp = nil,
    formatter = nil,
    linter = nil,
    dap = nil,
  },

  vim = {
    filetypes = { "vim" },
    treesitter = "vim",
    lsp = nil,
    formatter = nil,
    linter = nil,
    dap = nil,
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
    dap = nil,
  },

  nu = {
    filetypes = { "nu" },
    treesitter = "nu",
    lsp = {
      name = "nushell",
      mason = false,
    },
    formatter = nil,
    linter = nil,
    dap = nil,
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
    linter = nil,
    dap = nil,
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
    linter = nil,
    dap = nil,
  },

  toml = {
    filetypes = { "toml", "tml" },
    treesitter = "toml",
    lsp = {
      name = "tombi",
    },
    formatter = nil,
    linter = nil,
    dap = nil,
  },

  just = {
    filetypes = { "just" },
    treesitter = "just",
    lsp = {
      name = "just-lsp",
    },
    formatter = nil,
    linter = nil,
    dap = nil,
  },
}

return M
