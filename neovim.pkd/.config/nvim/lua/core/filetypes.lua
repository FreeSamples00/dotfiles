-- mappings for dotfiles types
local dot_mappings = {
  ["zshrc"] = "zsh",
  ["bashrc"] = "bash",
  ["vimrc"] = "vim",
  ["screenrc"] = "screen",
  ["gitconfig"] = "toml",
}

vim.filetype.add({
  pattern = {
    -- map '.foo' files
    [".*/%.([%w_-]+)$"] = function(_, _, name)
      return dot_mappings[name] or name
    end,
    -- map 'dot-foo' files
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
