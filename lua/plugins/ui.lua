local gh = require('core.utils').gh

  -- [[ Installing and Configuring Plugins ]]
  --
  -- To install a plugin simply call `vim.pack.add` with its git url.
  -- This will download the default branch of the plugin, which will usually be `main` or `master`
  -- You can also have more advanced specs, which we will talk about later.
  --
  -- For most plugins its not enough to install them, you also need to call their `.setup()` to start them.
  --
  -- For example, lets say we want to install `guess-indent.nvim` - a plugin for
  -- automatically detecting and setting the indentation.
  --
  -- We first install it from https://github.com/NMAC427/guess-indent.nvim
  -- and then call its `setup()` function to start it with default settings.
  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  -- Here is a more advanced configuration example that passes options to `gitsigns.nvim`
  --
  -- See `:help gitsigns` to understand what each configuration key does.
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
  require('gitsigns').setup {
    signs = {
      add = { text = '+' }, ---@diagnostic disable-line: missing-fields
      change = { text = '~' }, ---@diagnostic disable-line: missing-fields
      delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
      topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
      changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
    },
  }

  -- Useful plugin to show you pending keybinds.
  vim.pack.add { gh 'folke/which-key.nvim' }
  require('which-key').setup {
    -- Delay between pressing a key and opening which-key (milliseconds)
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    -- Document existing key chains
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
      { '<leader>o', group = '[O]bsidian' },
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
    },
  }

  -- [[ Colorscheme ]]
  -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command under that to load whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  -- vim.pack.add { gh 'folke/tokyonight.nvim' }
  -- ---@diagnostic disable-next-line: missing-fields
  -- require('tokyonight').setup {
  --   styles = {
  --     comments = { italic = false }, -- Disable italics in comments
  --   },
  -- }

  -- Load the colorscheme here.
  -- Like many other themes, this one has different styles, and you could load
  -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  vim.pack.add { gh 'RRethy/base16-nvim' }

  -- Highlight todo, notes, etc in comments
  vim.pack.add { gh 'folke/todo-comments.nvim' }
  require('todo-comments').setup { signs = false }

  -- [[ mini.nvim ]]
  --  A collection of various small independent plugins/modules
  vim.pack.add { gh 'nvim-mini/mini.nvim' }

  -- If a nerd font is available, load the icons module for pretty icons in various plugins.
  if vim.g.have_nerd_font then
    require('mini.icons').setup()
    -- Used for backwards compatibility with plugins that require `nvim-web-devicons` (e.g. telescope.nvim)
    MiniIcons.mock_nvim_web_devicons()
  end

  -- Better Around/Inside textobjects
  --
  -- Examples:
  --  - va)  - [V]isually select [A]round [)]paren
  --  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
  --  - ci'  - [C]hange [I]nside [']quote
  require('mini.ai').setup {
    -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
    mappings = {
      around_next = 'aa',
      inside_next = 'ii',
    },
    n_lines = 500,
  }

  -- Add/delete/replace surroundings (brackets, quotes, etc.)
  --
  -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
  -- - sd'   - [S]urround [D]elete [']quotes
  -- - sr)'  - [S]urround [R]eplace [)] [']
  require('mini.surround').setup()

  -- Simple and easy statusline.
  --  You could remove this setup call if you don't like it,
  --  and try some other statusline plugin
  local statusline = require 'ministatusline'
  -- Set `use_icons` to true if you have a Nerd Font
  statusline.setup { use_icons = vim.g.have_nerd_font }

  -- You can configure sections in the statusline by overriding their
  -- default behavior. For example, here we set the section for
  -- cursor location to LINE:COLUMN
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function() return '%2l:%-2v' end

  -- Monkey-patch base16-colorscheme so we know when matugen applies colors
  local ok, b16 = pcall(require, 'base16-colorscheme')
  if ok then
    local orig_setup = b16.setup
    b16.setup = function(...)
      orig_setup(...)
      -- Fire custom event so statusline knows to update.
      -- Must be synchronous to avoid race conditions during blocking prompts.
      vim.api.nvim_exec_autocmds("User", { pattern = "Base16ColorschemeLoaded", modeline = false })
    end
  end

  -- Apply Matugen colors and exact transparency for the middle
  vim.api.nvim_create_autocmd("User", {
    pattern = "Base16ColorschemeLoaded",
    callback = function()
      -- Get matugen colors
      local ok, b16 = pcall(require, 'base16-colorscheme')
      if not ok or not b16.colors then return end
      local c = b16.colors

      local set_hl = function(name, fg, bg, bold)
        vim.api.nvim_set_hl(0, name, { fg = fg, bg = bg, bold = bold })
      end

      -- Solid background for side elements
      local side_bg = c.base01
      local mode_fg = c.base00
      local text_fg = c.base05

      -- Left side (Modes)
      set_hl('MiniStatuslineModeNormal',  mode_fg, c.base0D, true)
      set_hl('MiniStatuslineModeInsert',  mode_fg, c.base0B, true)
      set_hl('MiniStatuslineModeVisual',  mode_fg, c.base0E, true)
      set_hl('MiniStatuslineModeReplace', mode_fg, c.base08, true)
      set_hl('MiniStatuslineModeCommand', mode_fg, c.base09, true)
      set_hl('MiniStatuslineModeOther',   mode_fg, c.base0E, true)

      -- Solid block notifications (Snacks) - Unified color for all types
      set_hl('SnacksNotifierInfo',  mode_fg, c.base0D, false)
      set_hl('SnacksNotifierWarn',  mode_fg, c.base0D, false)
      set_hl('SnacksNotifierError', mode_fg, c.base0D, false)
      set_hl('SnacksNotifierDebug', mode_fg, c.base0D, false)
      set_hl('SnacksNotifierTrace', mode_fg, c.base0D, false)
      set_hl('SnacksNotifierIconInfo',  mode_fg, c.base0D, false)
      set_hl('SnacksNotifierIconWarn',  mode_fg, c.base0D, false)
      set_hl('SnacksNotifierIconError', mode_fg, c.base0D, false)
      set_hl('SnacksNotifierIconDebug', mode_fg, c.base0D, false)
      set_hl('SnacksNotifierIconTrace', mode_fg, c.base0D, false)

      -- Left/Right inner panels
      set_hl('MiniStatuslineDevinfo',  text_fg, side_bg, false)
      set_hl('MiniStatuslineFileinfo', text_fg, side_bg, false)

      -- Middle part (Filename + empty space) MUST be perfectly transparent
      set_hl('MiniStatuslineFilename', text_fg, "NONE", true)
      vim.api.nvim_set_hl(0, "StatusLine",   { bg = "NONE", fg = "NONE" })
      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", fg = "NONE" })
    end
  })

  -- ... and there is more!
  --  Check out: https://github.com/nvim-mini/mini.nvim
