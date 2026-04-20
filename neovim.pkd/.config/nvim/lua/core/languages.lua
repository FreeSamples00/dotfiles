local M = {}

-------------------------------------------------------------------------------
-- List of languages installed by default
-------------------------------------------------------------------------------

M.ensure_installed = { "lua", "markdown", "vim", "json", "toml", "yaml" }

-------------------------------------------------------------------------------
-- LSP config name -> Mason package name mapping
-------------------------------------------------------------------------------

M.lsp_to_mason = {
  lua_ls = "lua-language-server",
  pylsp = "python-lsp-server",
  marksman = "marksman",
  texlab = "texlab",
  ts_ls = "typescript-language-server",
  jsonls = "json-lsp",
  yamlls = "yaml-language-server",
  jdtls = "jdtls",
}

-------------------------------------------------------------------------------
-- Language Definitions
-------------------------------------------------------------------------------

M.languages = {
  lua = {
    filetypes = { "lua" },
    treesitter = "lua",
    lsp = {
      name = "lua_ls",
      enabled = true,
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
      enabled = true,
    },
    linter = nil,
    dap = nil,
  },

  python = {
    filetypes = { "python", "py" },
    treesitter = "python",
    lsp = {
      name = "pylsp",
      enabled = true,
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
      enabled = true,
    },
    linter = nil,
    dap = {
      name = "debugpy",
      enabled = false,
    },
  },

  typescript = {
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "tsx", "jsx" },
    treesitter = { "typescript", "tsx", "javascript", "jsdoc" },
    lsp = {
      name = "ts_ls",
      enabled = true,
    },
    formatter = {
      name = "prettier",
      enabled = true,
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
      enabled = true,
    },
    formatter = {
      name = "google_java_format",
      enabled = true,
    },
    linter = nil,
    dap = nil,
  },

  markdown = {
    filetypes = { "markdown", "markdown.mdx", "md" },
    treesitter = { "markdown", "markdown_inline" },
    lsp = {
      name = "marksman",
      enabled = true,
    },
    formatter = {
      name = "prettier",
      enabled = true,
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
      enabled = true,
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
      enabled = true,
    },
    formatter = {
      name = "gofumpt",
      enabled = true,
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

  nu = {
    filetypes = { "nu" },
    treesitter = "nu",
    lsp = {
      name = "nushell",
      enabled = true,
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
      enabled = true,
    },
    formatter = {
      name = "prettier",
      enabled = true,
    },
    linter = nil,
    dap = nil,
  },

  yaml = {
    filetypes = { "yml", "yaml" },
    treesitter = "yaml",
    lsp = {
      name = "yamlls",
      enabled = true,
    },
    formatter = {
      name = "prettier",
      enabled = true,
    },
    linter = nil,
    dap = nil,
  },

  toml = {
    filetypes = { "toml", "tml" },
    treesitter = "toml",
    lsp = {
      name = "tombi",
      enabled = true,
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
      enabled = true,
    },
    formatter = nil,
    linter = nil,
    dap = nil,
  },
}

-------------------------------------------------------------------------------
-- State Checking Functions
-------------------------------------------------------------------------------

local function is_mason_installed(pkg_name)
  if not pkg_name then
    return false
  end
  local registry = require("mason-registry")
  local ok, pkg = pcall(registry.get_package, pkg_name)
  return ok and pkg:is_installed()
end

local function is_treesitter_installed(parser_name)
  if not parser_name then
    return false
  end
  local ok, _ = pcall(vim.treesitter.language.inspect, parser_name)
  return ok
end

function M.is_installed(lang_name)
  local lang = M.languages[lang_name]
  if not lang then
    return nil
  end

  local status = {
    language = lang_name,
    treesitter = true,
    lsp = true,
    formatter = true,
    linter = true,
    dap = true,
    complete = true,
  }

  if lang.treesitter then
    local parsers = type(lang.treesitter) == "table" and lang.treesitter or { lang.treesitter }
    for _, parser in ipairs(parsers) do
      if not is_treesitter_installed(parser) then
        status.treesitter = false
        status.complete = false
        break
      end
    end
  end

  if lang.lsp and lang.lsp.enabled then
    if lang.lsp.mason == false then
      status.lsp = vim.fn.executable(lang.lsp.name) == 1
    else
      local mason_name = M.lsp_to_mason[lang.lsp.name] or lang.lsp.name
      status.lsp = is_mason_installed(mason_name)
    end
    if not status.lsp then
      status.complete = false
    end
  end

  if lang.formatter and lang.formatter.enabled then
    if lang.formatter.mason == false then
      status.formatter = vim.fn.executable(lang.formatter.name) == 1
    else
      status.formatter = is_mason_installed(lang.formatter.name)
    end
    if not status.formatter then
      status.complete = false
    end
  end

  if lang.linter and lang.linter.enabled then
    if lang.linter.mason == false then
      status.linter = vim.fn.executable(lang.linter.name) == 1
    else
      status.linter = is_mason_installed(lang.linter.name)
    end
    if not status.linter then
      status.complete = false
    end
  end

  if lang.dap and lang.dap.enabled then
    if lang.dap.mason == false then
      status.dap = vim.fn.executable(lang.dap.name) == 1
    else
      status.dap = is_mason_installed(lang.dap.name)
    end
    if not status.dap then
      status.complete = false
    end
  end

  return status
end

-------------------------------------------------------------------------------
-- Tool Extraction Functions
-------------------------------------------------------------------------------

function M.get_ensure_installed_parsers()
  local parsers = {}
  for _, lang_name in ipairs(M.ensure_installed) do
    local lang = M.languages[lang_name]
    if lang and lang.treesitter then
      if type(lang.treesitter) == "table" then
        vim.list_extend(parsers, lang.treesitter)
      else
        table.insert(parsers, lang.treesitter)
      end
    end
  end
  return parsers
end

function M.get_ensure_installed_lsp_servers()
  local servers = {}
  for _, lang_name in ipairs(M.ensure_installed) do
    local lang = M.languages[lang_name]
    if lang and lang.lsp and lang.lsp.enabled and lang.lsp.mason ~= false then
      table.insert(servers, lang.lsp.name)
    end
  end
  return servers
end

function M.get_ensure_installed_mason_packages()
  local packages = {}
  for _, lang_name in ipairs(M.ensure_installed) do
    local lang = M.languages[lang_name]
    if lang then
      if lang.formatter and lang.formatter.enabled and lang.formatter.mason ~= false then
        table.insert(packages, lang.formatter.name)
      end
      if lang.linter and lang.linter.enabled and lang.linter.mason ~= false then
        table.insert(packages, lang.linter.name)
      end
      if lang.dap and lang.dap.enabled and lang.dap.mason ~= false then
        table.insert(packages, lang.dap.name)
      end
    end
  end
  return packages
end

function M.get_all_formatters()
  local formatters = {}
  for lang_name, lang in pairs(M.languages) do
    if lang.formatter and lang.formatter.enabled then
      formatters[lang_name] = lang.formatter
    end
  end
  return formatters
end

function M.get_all_linters()
  local linters = {}
  for lang_name, lang in pairs(M.languages) do
    if lang.linter and lang.linter.enabled then
      linters[lang_name] = lang.linter
    end
  end
  return linters
end

function M.get_all_lsp_configs()
  local configs = {}
  for lang_name, lang in pairs(M.languages) do
    if lang.lsp and lang.lsp.enabled then
      configs[lang_name] = lang.lsp
    end
  end
  return configs
end

function M.get_language_for_filetype(ft)
  for lang_name, lang in pairs(M.languages) do
    if vim.tbl_contains(lang.filetypes, ft) then
      return lang_name, lang
    end
  end
  return nil, nil
end

-------------------------------------------------------------------------------
-- Install/Uninstall Functions
-------------------------------------------------------------------------------

local function mason_install(pkg_name)
  local registry = require("mason-registry")
  local ok, pkg = pcall(registry.get_package, pkg_name)
  if ok and not pkg:is_installed() then
    pkg:install()
    return true
  end
  return false
end

local function mason_uninstall(pkg_name)
  local registry = require("mason-registry")
  local ok, pkg = pcall(registry.get_package, pkg_name)
  if ok and pkg:is_installed() then
    pkg:uninstall()
    return true
  end
  return false
end

function M.install_ensure_installed()
  for _, lang_name in ipairs(M.ensure_installed) do
    local lang = M.languages[lang_name]
    if not lang then
      return
    end

    if lang.lsp and lang.lsp.enabled and lang.lsp.mason ~= false then
      local mason_name = M.lsp_to_mason[lang.lsp.name] or lang.lsp.name
      mason_install(mason_name)
    end

    if lang.formatter and lang.formatter.enabled and lang.formatter.mason ~= false then
      mason_install(lang.formatter.name)
    end

    if lang.linter and lang.linter.enabled and lang.linter.mason ~= false then
      mason_install(lang.linter.name)
    end

    if lang.dap and lang.dap.enabled and lang.dap.mason ~= false then
      mason_install(lang.dap.name)
    end

    if lang.treesitter then
      local parsers = type(lang.treesitter) == "table" and lang.treesitter or { lang.treesitter }
      for _, parser in ipairs(parsers) do
        if not is_treesitter_installed(parser) then
          vim.cmd("TSInstall! " .. parser)
        end
      end
    end
  end
end

function M.install_language(lang_name)
  local lang = M.languages[lang_name]
  if not lang then
    vim.notify("Unknown language: " .. lang_name, vim.log.levels.ERROR)
    return false
  end

  local installed = {}
  local skipped = {}

  if lang.lsp and lang.lsp.enabled then
    if lang.lsp.mason ~= false then
      local mason_name = M.lsp_to_mason[lang.lsp.name] or lang.lsp.name
      if mason_install(mason_name) then
        table.insert(installed, lang.lsp.name .. " (LSP)")
      end
    else
      table.insert(skipped, lang.lsp.name .. " (non-Mason)")
    end
  end

  if lang.formatter and lang.formatter.enabled then
    if lang.formatter.mason ~= false then
      if mason_install(lang.formatter.name) then
        table.insert(installed, lang.formatter.name .. " (formatter)")
      end
    else
      table.insert(skipped, lang.formatter.name .. " (non-Mason)")
    end
  end

  if lang.linter and lang.linter.enabled then
    if lang.linter.mason ~= false then
      if mason_install(lang.linter.name) then
        table.insert(installed, lang.linter.name .. " (linter)")
      end
    else
      table.insert(skipped, lang.linter.name .. " (non-Mason)")
    end
  end

  if lang.dap and lang.dap.enabled then
    if lang.dap.mason ~= false then
      if mason_install(lang.dap.name) then
        table.insert(installed, lang.dap.name .. " (DAP)")
      end
    else
      table.insert(skipped, lang.dap.name .. " (non-Mason)")
    end
  end

  if lang.treesitter then
    local parsers = type(lang.treesitter) == "table" and lang.treesitter or { lang.treesitter }
    for _, parser in ipairs(parsers) do
      if not is_treesitter_installed(parser) then
        vim.cmd("TSInstall! " .. parser)
        table.insert(installed, "treesitter:" .. parser)
      end
    end
  end

  local message
  if #installed > 0 then
    message = string.format("Language '%s' installed: %s", lang_name, table.concat(installed, ", "))
  else
    message = string.format("Language '%s' - all tools already installed", lang_name)
  end
  if #skipped > 0 then
    message = message .. string.format("\nSkipped: %s", table.concat(skipped, ", "))
  end
  vim.notify(message, vim.log.levels.INFO)

  return true
end

function M.uninstall_language(lang_name)
  local lang = M.languages[lang_name]
  if not lang then
    vim.notify("Unknown language: " .. lang_name, vim.log.levels.ERROR)
    return false
  end

  local uninstalled = {}
  local skipped = {}

  if lang.lsp then
    if lang.lsp.mason ~= false then
      local mason_name = M.lsp_to_mason[lang.lsp.name] or lang.lsp.name
      if mason_uninstall(mason_name) then
        table.insert(uninstalled, lang.lsp.name)
      end
    else
      table.insert(skipped, lang.lsp.name .. " (non-Mason)")
    end
  end

  if lang.formatter then
    if lang.formatter.mason ~= false then
      if mason_uninstall(lang.formatter.name) then
        table.insert(uninstalled, lang.formatter.name)
      end
    else
      table.insert(skipped, lang.formatter.name .. " (non-Mason)")
    end
  end

  if lang.linter then
    if lang.linter.mason ~= false then
      if mason_uninstall(lang.linter.name) then
        table.insert(uninstalled, lang.linter.name)
      end
    else
      table.insert(skipped, lang.linter.name .. " (non-Mason)")
    end
  end

  if lang.dap then
    if lang.dap.mason ~= false then
      if mason_uninstall(lang.dap.name) then
        table.insert(uninstalled, lang.dap.name)
      end
    else
      table.insert(skipped, lang.dap.name .. " (non-Mason)")
    end
  end

  if lang.treesitter then
    local parsers = type(lang.treesitter) == "table" and lang.treesitter or { lang.treesitter }
    for _, parser in ipairs(parsers) do
      if is_treesitter_installed(parser) then
        vim.cmd("TSUninstall " .. parser)
        table.insert(uninstalled, "treesitter:" .. parser)
      end
    end
  end

  local message = string.format("Language '%s' uninstalled: %s", lang_name, table.concat(uninstalled, ", "))
  if #skipped > 0 then
    message = message .. string.format("\nSkipped: %s", table.concat(skipped, ", "))
  end
  vim.notify(message, vim.log.levels.INFO)

  return true
end

function M.status()
  local status = {}
  for lang_name, _ in pairs(M.languages) do
    status[lang_name] = M.is_installed(lang_name)
  end
  return status
end

return M
