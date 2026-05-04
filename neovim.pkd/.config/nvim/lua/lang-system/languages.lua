--- Language System Default Definitions
---
--- Provides default language configurations that can be overridden
--- by user opts in lua/plugins/lang-system.lua.
---
--- These defaults are merged with user opts using vim.tbl_deep_extend("force"),
--- so user values take precedence over defaults.

local M = {}

M.languages = {

  ---- LANGUAGE GROUP DEFINITIONS ----

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
    treesitter = {
      "ini",
      "git_config",
      "gitattributes",
      "gitignore",
      "editorconfig",
      "dockerfile",
      "ssh_config",
      "diff",
      "xml",
      "comment",
    },
  },

  ---- LANGUAGE DEFINITIONS ----

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
    formatter = {
      name = "nufmt",
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
