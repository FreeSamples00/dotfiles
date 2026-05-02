--- Language System Module
--- Entry point for language tooling configuration.
---
--- Provides setup functions for Mason, treesitter, LSP, and null-ls.
--- Language definitions are configured via setup(opts) from lazy.nvim.
--- Default definitions are in languages.lua and mappings.lua.

local M = {}

local functions = require("lang-system.functions")

-- Export core functions
M.is_mason_installed = functions.is_mason_installed
M.is_installed = functions.is_installed
M.install_ensure_installed = functions.install_ensure_installed
M.install_language = functions.install_language
M.uninstall_language = functions.uninstall_language
M.status = functions.status
M.get_ensure_installed_parsers = functions.get_ensure_installed_parsers
M.get_ensure_installed_lsp_servers = functions.get_ensure_installed_lsp_servers
M.get_ensure_installed_mason_packages = functions.get_ensure_installed_mason_packages
M.get_all_formatters = functions.get_all_formatters
M.get_all_linters = functions.get_all_linters
M.get_all_lsp_configs = functions.get_all_lsp_configs
M.get_language_for_filetype = functions.get_language_for_filetype
M.apply_tool_defaults = functions.apply_tool_defaults

-- Merged data (populated after setup())
M.languages = {}
M.lsp_to_mason = {}
M.tool_to_nullls = {}

function M.setup(opts)
  functions.setup(opts)

  -- Update merged data references after setup
  M.languages = functions.languages
  M.lsp_to_mason = functions.lsp_to_mason
  M.tool_to_nullls = functions.tool_to_nullls

  vim.api.nvim_create_user_command("AutoFormatToggle", function()
    vim.g.autoformat_enabled = not vim.g.autoformat_enabled
    vim.notify(
      string.format("Auto-formatting %s", vim.g.autoformat_enabled and "enabled" or "disabled"),
      vim.log.levels.INFO
    )
  end, { desc = "Toggle auto-formatting on save" })

  vim.api.nvim_create_user_command("LanguageInstall", function(opts)
    local lang_name = opts.args
    if lang_name == "" then
      local lang_names = vim.tbl_keys(M.languages)
      vim.ui.select(lang_names, {
        prompt = "Select language to install:",
      }, function(choice)
        if choice then
          M.install_language(choice)
        end
      end)
    else
      M.install_language(lang_name)
    end
  end, {
    nargs = "?",
    complete = function()
      return vim.tbl_keys(M.languages)
    end,
    desc = "Install language tools",
  })

  vim.api.nvim_create_user_command("LanguageUninstall", function(opts)
    local lang_name = opts.args
    local force = opts.bang
    if lang_name == "" then
      local lang_names = vim.tbl_keys(M.languages)
      vim.ui.select(lang_names, {
        prompt = "Select language to uninstall:",
      }, function(choice)
        if choice then
          M.uninstall_language(choice, { force = force })
        end
      end)
    else
      M.uninstall_language(lang_name, { force = force })
    end
  end, {
    nargs = "?",
    bang = true,
    complete = function()
      return vim.tbl_keys(M.languages)
    end,
    desc = "Uninstall language tools (use ! to force)",
  })

  vim.api.nvim_create_user_command("LanguageList", function()
    local lang_names = vim.tbl_keys(M.languages)
    table.sort(lang_names)
    vim.notify("Defined languages:\n" .. table.concat(lang_names, "\n"), vim.log.levels.INFO)
  end, { desc = "List all defined languages" })

  vim.api.nvim_create_user_command("LanguageStatus", function()
    local status = M.status()
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
      local lang = M.languages[item.name]
      local deps_str = ""
      if lang and lang.dependencies and #lang.dependencies > 0 then
        deps_str = " (depends: " .. table.concat(lang.dependencies, ", ") .. ")"
      end
      table.insert(lines, string.format("  %s %s%s", status_str, item.name, deps_str))
    end
    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
  end, { desc = "Show language installation status" })

  vim.api.nvim_create_user_command("LanguageInstallCurrent", function()
    local ft = vim.api.nvim_buf_get_option(0, "filetype")
    if ft == "" or ft == nil then
      vim.notify("No filetype detected for current buffer", vim.log.levels.WARN)
      return
    end
    local lang_name, lang = M.get_language_for_filetype(ft)
    if not lang_name then
      vim.notify("No language defined for filetype: " .. ft, vim.log.levels.WARN)
      return
    end
    M.install_language(lang_name)
  end, { desc = "Install tools for current buffer's language" })

  vim.api.nvim_create_user_command("LanguageUninstallCurrent", function()
    local ft = vim.api.nvim_buf_get_option(0, "filetype")
    if ft == "" or ft == nil then
      vim.notify("No filetype detected for current buffer", vim.log.levels.WARN)
      return
    end
    local lang_name, lang = M.get_language_for_filetype(ft)
    if not lang_name then
      vim.notify("No language defined for filetype: " .. ft, vim.log.levels.WARN)
      return
    end
    M.uninstall_language(lang_name)
  end, { desc = "Uninstall tools for current buffer's language" })

  local notified_languages = {}

  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("LanguageNotification", { clear = true }),
    callback = function()
      local ft = vim.api.nvim_buf_get_option(0, "filetype")
      if ft == "" or ft == nil then
        return
      end

      local lang_name, lang = M.get_language_for_filetype(ft)
      if not lang_name then
        return
      end

      if notified_languages[lang_name] then
        return
      end

      local status = M.is_installed(lang_name)
      if not status then
        return
      end

      if not status.complete then
        notified_languages[lang_name] = true
        vim.notify(
          string.format("Language '%s' config available. Run :LanguageInstall %s to install", lang_name, lang_name),
          vim.log.levels.INFO
        )
      end
    end,
  })
end

function M.setup_mason()
  require("mason").setup()

  vim.defer_fn(function()
    M.install_ensure_installed()
  end, 100)
end

function M.setup_treesitter()
  require("nvim-treesitter.config").setup({
    ensure_installed = M.get_ensure_installed_parsers(),
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
end

function M.setup_lspconfig()
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
    local lang_name, lang = M.get_language_for_filetype(ft)
    local formatter = M.apply_tool_defaults(lang and lang.formatter)
    if formatter and formatter.enable then
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

    lsp_map("<leader>ff", "<cmd>Format<cr>", bufnr, "Format")

    require("illuminate").on_attach(client)
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

  for lang_name, lsp in pairs(M.get_all_lsp_configs()) do
    local config = vim.tbl_deep_extend("force", {
      on_attach = on_attach,
      capabilities = capabilities,
    }, lsp.config or {})

    vim.lsp.config(lsp.name, config)
  end

  require("mason-lspconfig").setup({
    ensure_installed = M.get_ensure_installed_lsp_servers(),
    automatic_installation = true,
    automatic_enable = true,
  })
end

function M.setup_null_ls()
  local null_ls = require("null-ls")
  local sources = {}
  local formatters_by_name = {}

  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"

  local function get_source(method, name)
    local mapping = M.tool_to_nullls[method] and M.tool_to_nullls[method][name]

    if mapping and mapping.provider == "extras" then
      local ok, extra = pcall(require, "none-ls." .. method .. "." .. mapping.source)
      if ok then
        return extra, mapping
      else
        vim.notify(
          string.format(
            "[null-ls] failed to load extras source '%s.%s'; ensure none-ls-extras.nvim is installed",
            method,
            mapping.source
          ),
          vim.log.levels.WARN
        )
        return nil, nil
      end
    elseif mapping and mapping.provider == "builtin" then
      local builtin = null_ls.builtins[method][mapping.source]
      if builtin then
        return builtin, mapping
      else
        vim.notify(
          string.format(
            "[null-ls] builtin source '%s.%s' not found; this may indicate a null-ls version mismatch",
            method,
            mapping.source
          ),
          vim.log.levels.WARN
        )
        return nil, nil
      end
    else
      local builtin = null_ls.builtins[method][name]
      if builtin then
        return builtin, nil
      end
      vim.notify(
        string.format(
          "[null-ls] no source found for %s '%s'; add to mappings.lua or install the tool via Mason",
          method,
          name
        ),
        vim.log.levels.WARN
      )
      return nil, nil
    end
  end

  for lang_name, formatter in pairs(M.get_all_formatters()) do
    local name = formatter.name
    if not formatters_by_name[name] then
      formatters_by_name[name] = { config = formatter.config, mason = formatter.mason }
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
    local source, mapping = get_source("formatting", name)
    if source then
      local opts = {
        condition = function()
          if formatter_data.mason == false then
            return vim.fn.executable(name) == 1
          else
            return M.is_mason_installed(name)
          end
        end,
      }
      if mapping and mapping.provider == "extras" and formatter_data.mason ~= false then
        opts.command = mason_bin .. name
      end
      if formatter_data.config then
        opts = vim.tbl_extend("force", opts, formatter_data.config)
      end
      if source.with then
        source = source.with(opts)
      end
      table.insert(sources, source)
    end
  end

  for lang_name, linter in pairs(M.get_all_linters()) do
    local source, mapping = get_source("diagnostics", linter.name)
    if source then
      local opts = {
        condition = function()
          if linter.mason == false then
            return vim.fn.executable(linter.name) == 1
          else
            return M.is_mason_installed(linter.name)
          end
        end,
      }
      if mapping and mapping.provider == "extras" and linter.mason ~= false then
        opts.command = mason_bin .. linter.name
      end
      if linter.config then
        opts = vim.tbl_extend("force", opts, linter.config)
      end
      if source.with then
        source = source.with(opts)
      end
      table.insert(sources, source)
    end
  end

  null_ls.setup({ sources = sources })
end

return M
