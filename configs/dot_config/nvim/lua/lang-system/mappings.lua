--- Language Tool Name Mappings
---
--- LSP server names to Mason package names (lsp_to_mason).
---
--- lsp_to_mason holds ONLY explicit overrides. Most server names resolve
--- mechanically via M.get_mason_name() in functions.lua:
---   a. explicit override (this table)
---   b. underscore → dash            (rust_analyzer → rust-analyzer)
---   c. trailing "_ls"/"ls" suffix   (bashls → bash-language-server)
---   d. first candidate found in the Mason registry
--- Only add entries here when derivation (b/c) fails.
--- Formatter/linter names need no mapping: conform.nvim and nvim-lint
--- address tools by their executable names, matching languages.lua.
--- Source: mason-lspconfig package specs. Maintained manually.
--- See lua/lang-system/README.md for usage documentation.

local M = {}

--- Map from lspconfig server name to Mason package name (overrides only).
--- @type table<string, string>
M.lsp_to_mason = {
  astro = "astro-language-server",
  autohotkey_lsp = "autohotkey",
  azure_pipelines_ls = "azure-pipelines-language-server",
  beancount = "beancount-language-server",
  bicep = "bicep-lsp",
  bright_script = "brighterscript",
  buf_ls = "buf",
  c3lsp = "c3-lsp",
  cmake = "cmake-language-server",
  cobol_ls = "cobol-language-support",
  css_variables = "css-variables-language-server",
  cssls = "css-lsp",
  dagger = "cuelsp",
  dhl_lsp = "dhall-lsp",
  diagnosticls = "diagnostic-languageserver",
  djls = "django-language-server",
  djlsp = "django-template-lsp",
  dockerls = "dockerfile-language-server",
  earthls = "earthlyls",
  elixirls = "elixir-ls",
  elp = "erlang-ls",
  ember = "ember-language-server",
  emmylua_ls = "emmylua",
  eslint = "eslint-lsp",
  gh_actions_ls = "gh-actions-language-server",
  ginko_ls = "ginko",
  glsl_analyzer = "glsl",
  golangci_lint_ls = "golangci-lint-langserver",
  grammarly = "grammarly-languageserver",
  graphql = "graphql-language-service-cli",
  html = "html-lsp",
  htmx = "htmx-lsp",
  jqls = "jq-lsp",
  jsonls = "json-lsp",
  julials = "julia-lsp",
  just = "just-lsp",
  lelwel_ls = "lelwel",
  ltex = "ltex-ls",
  ltex_plus = "ltex-ls-plus",
  m68k = "m68k-lsp-server",
  mm0_ls = "metamath-zero-lsp",
  neocmake = "neocmakelsp",
  nickel_ls = "nickel-lang-lsp",
  nil_ls = "nil",
  nim_langserver = "nimlangserver",
  nimls = "nimlsp",
  ocamllsp = "ocaml-lsp",
  postgres_lsp = "postgres-language-server",
  powershell_es = "powershell-editor-services",
  pylsp = "python-lsp-server",
  r_language_server = "r-languageserver",
  robotframework_ls = "robotframework-lsp",
  roc_ls = "roc",
  rpmspec = "rpm",
  shopify_theme_ls = "shopify-cli",
  solidity_ls_nomicfoundation = "nomicfoundation-solidity-language-server",
  somesass_ls = "some-sass-language-server",
  spectral = "spectral-language-server",
  stylelint_lsp = "stylelint-language-server",
  svelte = "svelte-language-server",
  tailwindcss = "tailwindcss-language-server",
  tclsp = "tclint",
  terraformls = "terraform-ls",
  tofuls = "tofu-ls",
  ts_ls = "typescript-language-server",
  unocss = "unocss-language-server",
  vhdl_ls = "vhdl-style-guide",
  vimls = "vim-language-server",
  visualforce_ls = "visualforce-language-server",
  vue_ls = "vue-language-server",
  wc_ls = "wc-language-server",
  yamlls = "yaml-language-server",
}

return M
