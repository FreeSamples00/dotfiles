--- Filetype detection for dotfiles (stow dot-** and .** naming conventions)
--- See: GNU stow dotfile naming patterns

-- explicit mappings for dotfiles whose extension doesn't match their syntax
local dot_mappings = {
  ["zshrc"] = "zsh",
  ["bashrc"] = "bash",
  ["vimrc"] = "vim",
  ["screenrc"] = "screen",
  ["gitconfig"] = "toml",
}

vim.filetype.add({
  pattern = {
    -- map '.foo' files (e.g. .zshrc → zsh)
    [".*/%.([%w_-]+)$"] = function(_, _, name)
      return dot_mappings[name] or name
    end,
    -- map 'dot-foo' files (stow convention, e.g. dot-zshrc → zsh)
    [".*/dot%-([%w_-]+)$"] = function(_, _, name)
      return dot_mappings[name] or name
    end,
  },
  extension = {
    tex = "tex",
    bib = "tex",
    aux = "tex",
  },
  filename = {
    --["foo"] = "bar"
  },
})
