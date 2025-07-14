return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",

  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      -- {
      --   name = "school",
      --   path = "~/obsidian/School",
      -- },
      -- {
      --   name = "xinu",
      --   path = "~/obsidian/xinu-research",
      -- },
      {
        name = "notes",
        path = "~/notes",
        overrides = {
          templates = {
            folder = ".templates",
            date_format = "%m/%d/%Y",
            time_format = "%H:%M",
          },
        },
      },
      {
        name = "no-vault",
        path = function()
          -- alternatively use the CWD:
          -- return assert(vim.fn.getcwd())
          return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
        end,
        overrides = {
          notes_subdir = vim.NIL, -- have to use 'vim.NIL' instead of 'nil'
          new_notes_location = "current_dir",
          -- templates = {
          --   folder = ".templates",
          --   date_format = "%m/%d/%Y",
          --   time_format = "%H:%M",
          -- },
          disable_frontmatter = true,
        },
      },
    },

    disable_frontmatter = true,
    notes_subdir = vim.NIL, -- have to use 'vim.NIL' instead of 'nil'
    new_notes_location = "current_dir",

    attachments = {
      -- The default folder to place images in via `:ObsidianPasteImg`.
      -- If this is a relative path it will be interpreted as relative to the vault root.
      -- You can always override this per image by passing a full path to the command instead of just a filename.
      img_folder = ".attachments/",

      -- A function that determines the text to insert in the note when pasting an image.
      -- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
      -- This is the default implementation.
      ---@param client obsidian.Client
      ---@param path obsidian.Path the absolute path to the image file
      ---@return string
      img_text_func = function(client, path)
        path = client:vault_relative_path(path) or path
        return string.format("![%s](%s)", path.name, path)
      end,
    },

    -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
    completion = {
      -- Enables completion using nvim_cmp
      nvim_cmp = false,
      -- Enables completion using blink.cmp
      blink = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
      -- Set to false to disable new note creation in the picker
      create_new = true,
    },

    -- opening in obsidian
    open = {
      use_advanced_uri = false,
      func = vim.ui.open,
    },

    -- follow url
    follow_url_func = function(url)
      vim.fn.jobstart({ "open", url })
    end,

    -- follow image path
    follow_img_func = function(img)
      vim.fn.jobstart({ "qlmanage", "-p", img })
    end,

    -- search result sorting
    sort_by = "modified",
    sort_reversed = true,

    -- picker config
    picker = {
      name = "snacks.pick",
      note_mappings = {
        new = "<C-x>",
        insert_link = "<C-l",
      },
      tag_mappings = {
        tag_note = "<C-x>",
        insert_tag = "<C-l>",
      },
    },

    -- See https://github.com/obsidian-nvim/obsidian.nvim/wiki/Notes-on-configuration#statusline-component
    lualine = {
      enabled = true,
      format = "{{properties}} properties {{backlinks}} backlinks {{words}} words {{chars}} chars",
    },

    -- see below for full list of options 👇
  },

  preferred_link_style = "wiki",

  -- keybinds
  config = function(_, opts)
    require("obsidian").setup(opts)

    -- remove keybinds
    vim.api.nvim_create_autocmd("User", {
      pattern = "ObsidianNoteEnter",
      callback = function(ev)
        vim.keymap.del("n", "<CR>", { buffer = ev.buf })
      end,
    })

    -- setup keybinds
    vim.api.nvim_create_autocmd("User", {
      pattern = "ObsidianNoteEnter",
      callback = function()
        -- In Note
        vim.keymap.set("n", "<C-CR>", ":ObsidianToggleCheckbox<CR>", { desc = "Cycle Checkbox" })
        vim.keymap.set("n", "<leader>oc", ":Obsidian<CR>", { desc = "Open command menu" })
        vim.keymap.set("n", "<leader>ot", ":ObsidianTemplate<CR>", { desc = "Insert a template" })
        vim.keymap.set("n", "<leader>op", ":ObsidianPasteImg ", { desc = "Paste image (choose name)" })
        vim.keymap.set("n", "<leader>oP", ":ObsidianPasteImg<CR>", { desc = "Paste image (default name)" })
        -- Navigation
        vim.keymap.set("n", "<CR>", ":ObsidianFollowLink vsplit<CR>", { desc = "Follow link" })
        vim.keymap.set("n", "<leader>oo", ":ObsidianQuickSwitch<CR>", { desc = "Open note picker" })
        vim.keymap.set("n", "<leader>oT", ":ObsidianTOC<CR>", { desc = "Open table of contents" })
        vim.keymap.set("n", "<leader>ov", ":ObsidianWorkspace<CR>", { desc = "Switch vaults" })
        -- Links
        vim.keymap.set("n", "<leader>ol", "v:ObsidianLink<CR>", { desc = "Create a link" })
        vim.keymap.set("v", "<leader>ol", ":ObsidianLink<CR>", { desc = "Create link" })
        vim.keymap.set("n", "<leader>oL", ":ObsidianLinks<CR>", { desc = "Show links" })
        vim.keymap.set("n", "<leader>oB", ":ObsidianBacklinks<CR>", { desc = "Show backlinks" })
        -- Search
        vim.keymap.set("n", "<leader>os", ":ObsidianSearch<CR>", { desc = "Search notes" })
        vim.keymap.set("n", "<leader>o#", ":ObsidianTags<CR>", { desc = "Search tags" })
        -- New note
        vim.keymap.set("n", "<leader>on", ":ObsidianNew ", { desc = "Create a new note" })
        vim.keymap.set("n", "<leader>oN", "v:ObsidianLinkNew ", { desc = "Create and link new note" })
        vim.keymap.set("v", "<leader>on", ":ObsidianExtractNote ", { desc = "Extract text to note" })
      end,
    })
  end,
}
