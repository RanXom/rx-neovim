-- ============================================================================
-- OBSIDIAN
-- Obsidian vault integration: wiki-links, backlinks, daily notes, search
-- ============================================================================

local gh = require('core.utils').gh

vim.pack.add { { src = gh 'obsidian-nvim/obsidian.nvim', version = vim.version.range '3.*' } }

require('obsidian').setup {
  workspaces = {
    {
      name = 'personal',
      path = '~/vaults/personal',
    },
  },

  daily_notes = {
    folder = 'dailies',
    date_format = '%Y-%m-%d',
  },

  completion = {
    blink = true,
    nvim_cmp = false,
    min_chars = 2,
  },

  picker = {
    name = 'telescope.nvim',
  },

  -- Disable obsidian.nvim's built-in UI rendering.
  -- render-markdown.nvim handles all visual decorations instead.
  ui = {
    enable = false,
  },

  -- In-buffer mappings
  mappings = {
    -- Smart action: follows link, toggles checkbox, or searches tag
    ['<cr>'] = {
      action = function() return require('obsidian').util.smart_action() end,
      opts = { buffer = true, expr = true },
    },
    -- Follow wiki/markdown links (falls back to native gf outside vault)
    ['gf'] = {
      action = function() return require('obsidian').util.gf_passthrough() end,
      opts = { noremap = false, expr = true, buffer = true },
    },
  },
}

-- Obsidian keymaps
vim.keymap.set('n', '<leader>os', '<cmd>ObsidianQuickSwitch<cr>', { desc = 'Obsidian: Quick switch note' })
vim.keymap.set('n', '<leader>og', '<cmd>ObsidianSearch<cr>', { desc = 'Obsidian: Grep search vault' })
vim.keymap.set('n', '<leader>on', '<cmd>ObsidianNew<cr>', { desc = 'Obsidian: New note' })
vim.keymap.set('n', '<leader>ot', '<cmd>ObsidianTags<cr>', { desc = 'Obsidian: Find tags' })
vim.keymap.set('n', '<leader>ob', '<cmd>ObsidianBacklinks<cr>', { desc = 'Obsidian: Backlinks' })

-- Daily notes
vim.keymap.set('n', '<leader>od', '<cmd>ObsidianToday<cr>', { desc = 'Obsidian: Today\'s note' })
vim.keymap.set('n', '<leader>oD', '<cmd>ObsidianDailies<cr>', { desc = 'Obsidian: Daily notes picker' })

-- Tools
vim.keymap.set('n', '<leader>oo', '<cmd>ObsidianOpen<cr>', { desc = 'Obsidian: Open in desktop app' })
vim.keymap.set('n', '<leader>or', '<cmd>ObsidianRename<cr>', { desc = 'Obsidian: Rename note & references' })
vim.keymap.set('n', '<leader>oi', '<cmd>ObsidianPasteImg<cr>', { desc = 'Obsidian: Paste clipboard image' })
vim.keymap.set('n', '<leader>op', '<cmd>ObsidianTemplate<cr>', { desc = 'Obsidian: Insert template' })

-- Visual mode
vim.keymap.set('v', '<leader>ol', ':<C-u>ObsidianLink<cr>', { desc = 'Obsidian: Link selection to note' })
vim.keymap.set('v', '<leader>on', ':<C-u>ObsidianLinkNew<cr>', { desc = 'Obsidian: Link selection to new note' })
vim.keymap.set('v', '<leader>oe', ':<C-u>ObsidianExtractNote<cr>', { desc = 'Obsidian: Extract selection to new note' })
