--- Language System Module
--- Entry point for language tooling configuration.
---
--- Provides setup functions for Mason, treesitter, LSP, conform (formatters),
--- and nvim-lint (linters).
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
M.get_all_formatters = functions.get_all_formatters
M.get_all_linters = functions.get_all_linters
M.get_all_lsp_configs = functions.get_all_lsp_configs
M.get_language_for_filetype = functions.get_language_for_filetype
M.apply_tool_defaults = functions.apply_tool_defaults

-- Merged data (populated after setup())
M.languages = {}
M.lsp_to_mason = {}

function M.setup(opts)
  functions.setup(opts)

  -- Update merged data references after setup
  M.languages = functions.languages
  M.lsp_to_mason = functions.lsp_to_mason

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
    local ft = vim.bo[0].filetype
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
    local ft = vim.bo[0].filetype
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
      local ft = vim.bo[0].filetype
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
  require("mason").setup({
    ui = {
      border = "rounded",
    },
  })

  vim.defer_fn(function()
    M.install_ensure_installed()
  end, 100)
end

function M.setup_treesitter()
  -- textobjects configuration (nvim-treesitter-textobjects main branch API)
  require("nvim-treesitter-textobjects").setup({
    move = {
      set_jumps = true, -- jump list entries for function motions
    },
  })

  local ts_move = require("nvim-treesitter-textobjects.move")
  local map = require("helpers.keys").map
  map({ "n", "x", "o" }, "]m", function()
    ts_move.goto_next_start("@function.outer", "textobjects")
  end, "Next function start")
  map({ "n", "x", "o" }, "]M", function()
    ts_move.goto_next_end("@function.outer", "textobjects")
  end, "Next function end")
  map({ "n", "x", "o" }, "[m", function()
    ts_move.goto_previous_start("@function.outer", "textobjects")
  end, "Previous function start")
  map({ "n", "x", "o" }, "[M", function()
    ts_move.goto_previous_end("@function.outer", "textobjects")
  end, "Previous function end")

  -- Start treesitter highlighting + indentation per buffer (main branch API).
  -- Highlighting and indentexpr are core/plugin features that must be
  -- enabled per filetype; no parser/query installed -> pcall fails silently.
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
      -- treesitter indentation is experimental; python ships a better ftplugin
      if args.match ~= "python" then
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end

function M.setup_lspconfig()
  local globals = require("helpers.globals")

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

    local ft = vim.bo[bufnr].filetype
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

    lsp_map("<leader>ff", "<cmd>Format<cr>", bufnr, "Format")
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

  for lang_name, lsp in pairs(M.get_all_lsp_configs()) do
    local config = vim.tbl_deep_extend("force", {
      on_attach = on_attach,
      capabilities = capabilities,
    }, lsp.config or {})

    vim.lsp.config(lsp.name, config)
  end

  for lang_name, lsp in pairs(M.get_all_lsp_configs()) do
    if lsp.mason == false then
      vim.lsp.enable(lsp.name)
    end
  end

  -- Exclude formatter/linter/dap tool names from automatic enabling:
  -- some (e.g. stylua, which ships an --lsp mode) have Mason package specs
  -- declaring an lspconfig name, and would otherwise attach as LSP servers
  -- alongside conform.
  local exclude = {}
  for _, lang in pairs(M.languages) do
    for _, tool_key in ipairs({ "formatter", "linter", "dap" }) do
      local tool = M.apply_tool_defaults(lang[tool_key])
      if tool and tool.name then
        exclude[#exclude + 1] = tool.name
      end
    end
  end

  require("mason-lspconfig").setup({
    ensure_installed = M.get_ensure_installed_lsp_servers(),
    automatic_enable = { exclude = exclude },
  })
end

function M.setup_conform()
  local conform = require("conform")

  -- formatters_by_ft: filetype → formatter names, derived from language defs.
  -- A formatter's config.filetypes overrides the language's filetypes
  -- (e.g. prettier for typescript also covers json).
  local formatters_by_ft = {}
  local formatter_opts = {} -- per-tool conform formatter config (extra_args)

  for _, lang in pairs(M.languages) do
    local formatter = M.apply_tool_defaults(lang.formatter)
    if formatter and formatter.enable then
      local fts = (formatter.config and formatter.config.filetypes) or lang.filetypes or {}
      for _, ft in ipairs(fts) do
        local list = formatters_by_ft[ft] or {}
        if not vim.tbl_contains(list, formatter.name) then
          table.insert(list, formatter.name)
        end
        formatters_by_ft[ft] = list
      end
      if formatter.extra_args then
        formatter_opts[formatter.name] = { append_args = formatter.extra_args }
      end
    end
  end

  conform.setup({
    formatters_by_ft = formatters_by_ft,
    formatters = formatter_opts,
    -- respects vim.g.autoformat_enabled (toggled via :AutoFormatToggle / <leader>uf)
    format_on_save = function(bufnr)
      if vim.g.autoformat_enabled == false then
        return
      end
      return { timeout_ms = 1000, lsp_format = "fallback" }
    end,
  })

  vim.api.nvim_create_user_command("Format", function()
    conform.format({ lsp_format = "fallback", async = false })
  end, { desc = "Format buffer (conform with LSP fallback)" })
end

function M.setup_nvimlint()
  local lint = require("lint")

  local linters_by_ft = {}
  for _, lang in pairs(M.languages) do
    local linter = M.apply_tool_defaults(lang.linter)
    if linter and linter.enable then
      local fts = lang.filetypes or {}
      for _, ft in ipairs(fts) do
        local list = linters_by_ft[ft] or {}
        if not vim.tbl_contains(list, linter.name) then
          table.insert(list, linter.name)
        end
        linters_by_ft[ft] = list
      end
      if linter.extra_args and lint.linters[linter.name] then
        local linter_def = lint.linters[linter.name]
        linter_def.args = vim.list_extend(vim.deepcopy(linter_def.args or {}), linter.extra_args)
      end
    end
  end
  lint.linters_by_ft = linters_by_ft

  lint.try_lint()

  vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufEnter" }, {
    group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
    callback = function()
      lint.try_lint()
    end,
  })
end

return M
