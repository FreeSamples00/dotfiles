--- Language System Core Module
--- Provides helper functions for language tooling management.
---
--- Configuration is provided via setup(opts) from lua/plugins/lang-system.lua.
--- See lua/lang-system/README.md for usage documentation.

local mappings = require("lang-system.mappings")

local M = {}

local config = {
  ensure_installed = {},
  languages = {},
}

M.lsp_to_mason = mappings.lsp_to_mason

--- Setup function called by the plugin's config.
--- @param opts table Configuration with ensure_installed and languages
function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})
  M.ensure_installed = config.ensure_installed
  M.languages = config.languages
end

--- Check if a Mason package is installed.
--- @param pkg_name string Package name as known to Mason
--- @return boolean
function M.is_mason_installed(pkg_name)
  if not pkg_name then
    return false
  end
  local registry = require("mason-registry")
  local ok, pkg = pcall(registry.get_package, pkg_name)
  return ok and pkg:is_installed()
end

local function is_mason_installed(pkg_name)
  return M.is_mason_installed(pkg_name)
end

--- Apply default values to a tool definition.
--- Sets `enable = true` and `install = true` if not specified.
--- @param tool table|nil Tool definition from language config
--- @return table|nil
local function apply_tool_defaults(tool)
  if not tool then
    return nil
  end
  if tool.enable == nil then
    tool.enable = true
  end
  if tool.install == nil then
    tool.install = true
  end
  return tool
end

M.apply_tool_defaults = apply_tool_defaults

local function get_all_dependencies(lang_name, seen)
  seen = seen or {}
  if seen[lang_name] then
    return {}
  end
  seen[lang_name] = true

  local lang = M.languages[lang_name]
  if not lang or not lang.dependencies then
    return {}
  end

  local deps = {}
  for _, dep in ipairs(lang.dependencies) do
    if M.languages[dep] and not seen[dep] then
      table.insert(deps, dep)
      vim.list_extend(deps, get_all_dependencies(dep, seen))
    end
  end
  return deps
end

M.get_all_dependencies = get_all_dependencies

local function get_dependents(lang_name)
  local dependents = {}
  for name, lang in pairs(M.languages) do
    if lang.dependencies and vim.tbl_contains(lang.dependencies, lang_name) then
      table.insert(dependents, name)
    end
  end
  return dependents
end

local function is_treesitter_installed(parser_name)
  if not parser_name then
    return false
  end
  local ok, _ = pcall(vim.treesitter.language.inspect, parser_name)
  return ok
end

--- Check installation status of all tools for a language.
--- @param lang_name string Language name (e.g., "lua", "python")
--- @return table|nil Status table with fields: treesitter, lsp, formatter, linter, dap, dependencies, complete
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
    dependencies = true,
    complete = true,
  }

  local deps = get_all_dependencies(lang_name)
  for _, dep in ipairs(deps) do
    local dep_status = M.is_installed(dep)
    if not dep_status or not dep_status.complete then
      status.dependencies = false
      status.complete = false
      break
    end
  end

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

  local lsp = apply_tool_defaults(lang.lsp)
  if lsp and lsp.enable then
    if lsp.mason == false then
      status.lsp = vim.fn.executable(lsp.name) == 1
    else
      local mason_name = mappings.lsp_to_mason[lsp.name] or lsp.name
      status.lsp = is_mason_installed(mason_name)
    end
    if not status.lsp then
      status.complete = false
    end
  end

  local formatter = apply_tool_defaults(lang.formatter)
  if formatter and formatter.enable then
    if formatter.mason == false then
      status.formatter = vim.fn.executable(formatter.name) == 1
    else
      status.formatter = is_mason_installed(formatter.name)
    end
    if not status.formatter then
      status.complete = false
    end
  end

  local linter = apply_tool_defaults(lang.linter)
  if linter and linter.enable then
    if linter.mason == false then
      status.linter = vim.fn.executable(linter.name) == 1
    else
      status.linter = is_mason_installed(linter.name)
    end
    if not status.linter then
      status.complete = false
    end
  end

  local dap = apply_tool_defaults(lang.dap)
  if dap and dap.enable then
    if dap.mason == false then
      status.dap = vim.fn.executable(dap.name) == 1
    else
      status.dap = is_mason_installed(dap.name)
    end
    if not status.dap then
      status.complete = false
    end
  end

  return status
end

local function expand_with_dependencies(lang_list)
  local expanded = {}
  local seen = {}
  for _, lang_name in ipairs(lang_list) do
    if not seen[lang_name] then
      seen[lang_name] = true
      local deps = get_all_dependencies(lang_name)
      for _, dep in ipairs(deps) do
        if not seen[dep] then
          seen[dep] = true
          table.insert(expanded, dep)
        end
      end
      table.insert(expanded, lang_name)
    end
  end
  return expanded
end

--- Get treesitter parsers for ensure_installed languages.
--- @return string[]
function M.get_ensure_installed_parsers()
  local parsers = {}
  for _, lang_name in ipairs(expand_with_dependencies(M.ensure_installed)) do
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

--- Get LSP server names for ensure_installed languages.
--- Only includes servers with `install = true` and `mason != false`.
--- @return string[]
function M.get_ensure_installed_lsp_servers()
  local servers = {}
  for _, lang_name in ipairs(expand_with_dependencies(M.ensure_installed)) do
    local lang = M.languages[lang_name]
    local tool = apply_tool_defaults(lang and lang.lsp)
    if tool and tool.install and tool.mason ~= false then
      table.insert(servers, tool.name)
    end
  end
  return servers
end

--- Get Mason package names for formatters, linters, and DAPs in ensure_installed.
--- @return string[]
function M.get_ensure_installed_mason_packages()
  local packages = {}
  for _, lang_name in ipairs(expand_with_dependencies(M.ensure_installed)) do
    local lang = M.languages[lang_name]
    if lang then
      local formatter = apply_tool_defaults(lang.formatter)
      if formatter and formatter.install and formatter.mason ~= false then
        table.insert(packages, formatter.name)
      end
      local linter = apply_tool_defaults(lang.linter)
      if linter and linter.install and linter.mason ~= false then
        table.insert(packages, linter.name)
      end
      local dap = apply_tool_defaults(lang.dap)
      if dap and dap.install and dap.mason ~= false then
        table.insert(packages, dap.name)
      end
    end
  end
  return packages
end

--- Get all enabled formatters from language definitions.
--- @return table<string, table> Map of language name to formatter config
function M.get_all_formatters()
  local formatters = {}
  for lang_name, lang in pairs(M.languages) do
    local tool = apply_tool_defaults(lang.formatter)
    if tool and tool.enable then
      formatters[lang_name] = lang.formatter
    end
  end
  return formatters
end

--- Get all enabled linters from language definitions.
--- @return table<string, table> Map of language name to linter config
function M.get_all_linters()
  local linters = {}
  for lang_name, lang in pairs(M.languages) do
    local tool = apply_tool_defaults(lang.linter)
    if tool and tool.enable then
      linters[lang_name] = lang.linter
    end
  end
  return linters
end

--- Get all enabled LSP configs from language definitions.
--- @return table<string, table> Map of language name to LSP config
function M.get_all_lsp_configs()
  local configs = {}
  for lang_name, lang in pairs(M.languages) do
    local tool = apply_tool_defaults(lang.lsp)
    if tool and tool.enable then
      configs[lang_name] = lang.lsp
    end
  end
  return configs
end

--- Find language definition by filetype.
--- @param ft string Filetype to look up
--- @return string|nil, table|nil Language name and config, or nil if not found
function M.get_language_for_filetype(ft)
  for lang_name, lang in pairs(M.languages) do
    if lang.filetypes and vim.tbl_contains(lang.filetypes, ft) then
      return lang_name, lang
    end
  end
  return nil, nil
end

-- Install a Mason package if not already installed.
-- @param pkg_name string Mason package name
-- @return boolean True if installation was triggered
local function mason_install(pkg_name)
  local registry = require("mason-registry")
  local ok, pkg = pcall(registry.get_package, pkg_name)
  if ok and not pkg:is_installed() and not pkg:is_installing() then
    pkg:install()
    return true
  end
  return false
end

-- Uninstall a Mason package if installed.
-- @param pkg_name string Mason package name
-- @return boolean True if uninstallation was triggered
local function mason_uninstall(pkg_name)
  local registry = require("mason-registry")
  local ok, pkg = pcall(registry.get_package, pkg_name)
  if ok and pkg:is_installed() then
    pkg:uninstall()
    return true
  end
  return false
end

--- Install all tools for languages in ensure_installed list.
--- Called on startup by Mason config.
function M.install_ensure_installed()
  for _, lang_name in ipairs(M.ensure_installed) do
    local lang = M.languages[lang_name]
    if not lang then
      return
    end

    local lsp = apply_tool_defaults(lang.lsp)
    if lsp and lsp.install and lsp.mason ~= false then
      local mason_name = mappings.lsp_to_mason[lsp.name] or lsp.name
      mason_install(mason_name)
    end

    local formatter = apply_tool_defaults(lang.formatter)
    if formatter and formatter.install and formatter.mason ~= false then
      mason_install(formatter.name)
    end

    local linter = apply_tool_defaults(lang.linter)
    if linter and linter.install and linter.mason ~= false then
      mason_install(linter.name)
    end

    local dap = apply_tool_defaults(lang.dap)
    if dap and dap.install and dap.mason ~= false then
      mason_install(dap.name)
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

--- Install all tools for a specific language.
--- Notifies user of installed and skipped tools.
--- @param lang_name string Language name
--- @param opts table|nil Options: { skip_deps = boolean }
--- @return boolean Success
function M.install_language(lang_name, opts)
  opts = opts or {}
  local lang = M.languages[lang_name]
  if not lang then
    vim.notify("Unknown language: " .. lang_name, vim.log.levels.ERROR)
    return false
  end

  if not opts.skip_deps then
    local deps = get_all_dependencies(lang_name)
    for _, dep in ipairs(deps) do
      M.install_language(dep, { skip_deps = true })
    end
  end

  local installed = {}
  local skipped = {}

  local lsp = apply_tool_defaults(lang.lsp)
  if lsp and lsp.install then
    if lsp.mason ~= false then
      local mason_name = mappings.lsp_to_mason[lsp.name] or lsp.name
      if mason_install(mason_name) then
        table.insert(installed, lsp.name .. " (LSP)")
      end
    else
      table.insert(skipped, lsp.name .. " (non-Mason)")
    end
  end

  local formatter = apply_tool_defaults(lang.formatter)
  if formatter and formatter.install then
    if formatter.mason ~= false then
      if mason_install(formatter.name) then
        table.insert(installed, formatter.name .. " (formatter)")
      end
    else
      table.insert(skipped, formatter.name .. " (non-Mason)")
    end
  end

  local linter = apply_tool_defaults(lang.linter)
  if linter and linter.install then
    if linter.mason ~= false then
      if mason_install(linter.name) then
        table.insert(installed, linter.name .. " (linter)")
      end
    else
      table.insert(skipped, linter.name .. " (non-Mason)")
    end
  end

  local dap = apply_tool_defaults(lang.dap)
  if dap and dap.install then
    if dap.mason ~= false then
      if mason_install(dap.name) then
        table.insert(installed, dap.name .. " (DAP)")
      end
    else
      table.insert(skipped, dap.name .. " (non-Mason)")
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

--- Uninstall all tools for a specific language.
--- @param lang_name string Language name
--- @param opts table|nil Options: { force = boolean }
--- @return boolean Success
function M.uninstall_language(lang_name, opts)
  opts = opts or {}
  local lang = M.languages[lang_name]
  if not lang then
    vim.notify("Unknown language: " .. lang_name, vim.log.levels.ERROR)
    return false
  end

  local dependents = get_dependents(lang_name)
  if #dependents > 0 and not opts.force then
    vim.notify(
      string.format(
        "Cannot uninstall '%s': required by %s. Use :LanguageUninstall! %s to force.",
        lang_name,
        table.concat(dependents, ", "),
        lang_name
      ),
      vim.log.levels.WARN
    )
    return false
  end

  local uninstalled = {}
  local skipped = {}

  if lang.lsp then
    if lang.lsp.mason ~= false then
      local mason_name = mappings.lsp_to_mason[lang.lsp.name] or lang.lsp.name
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

--- Get installation status for all defined languages.
--- @return table<string, table> Map of language name to status table
function M.status()
  local status = {}
  for lang_name, _ in pairs(M.languages) do
    status[lang_name] = M.is_installed(lang_name)
  end
  return status
end

return M
