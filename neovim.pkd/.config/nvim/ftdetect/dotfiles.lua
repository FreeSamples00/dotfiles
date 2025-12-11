-- Automatically detect filetype for dot-XXXXX files
-- Maps dot-XXXXX → filetype XXXXX
vim.filetype.add({
  pattern = {
    ["dot%-(.+)"] = function(_, _, ext)
      return ext
    end,
  },
})
