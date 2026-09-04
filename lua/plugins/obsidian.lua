-- ============================================================================
-- OBSIDIAN
-- Obsidian vault integration: wiki-links, backlinks, daily notes, search
-- ============================================================================

local gh = require('core.utils').gh

vim.pack.add { { src = gh 'obsidian-nvim/obsidian.nvim', version = vim.version.range '3.*' } }

require('obsidian').setup {
  workspaces = {
    {
      name = 'Lessons',
      path = '~/Documents/Obsidian/Lessons',
    },
  },

  picker = {
    name = 'telescope.nvim',
  },

  notes_subdir = "6 - Main Notes",

  templates = {
    subdir = "5 - Templates",
    date_format = "%d-%m-%Y %H:%M %p",
    time_format = "%H:%M",
  },

  frontmatter = {
    func = function(note)
      return {}
    end,
  },

  note_id_func = function(title)
    if title ~= nil then
      return title
    else
      return tostring(os.time())
    end
  end,

  new_notes_location = "notes_subdir",

 -- Disable obsidian.nvim's built-in UI rendering.
  -- render-markdown.nvim handles all visual decorations instead.
  ui = {
    enable = false,
  },

  legacy_commands = false,
}

-- Obsidian keymaps
vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian quick_switch<CR>", { desc = "Obsidian: Quick Switch" })
vim.keymap.set('n', '<leader>og', '<cmd>Obsidian search<cr>', { desc = 'Obsidian: Grep search vault' })
vim.keymap.set('n', '<leader>on', '<cmd>Obsidian new<cr>', { desc = 'Obsidian: New note' })
vim.keymap.set("n", "<leader>om", "<cmd>Obsidian rename<CR>", { desc = "Obsidian: Rename/Move Note" })
vim.keymap.set('n', '<leader>ot', '<cmd>Obsidian template<cr>', { desc = 'Obsidian: Apply Template' })
vim.keymap.set('n', '<leader>ob', '<cmd>Obsidian backlinks<cr>', { desc = 'Obsidian: Backlinks' })
vim.keymap.set("n", "<leader>of", "<cmd>Obsidian follow_link<CR>", { desc = "Obsidian: Follow Link" })

-- Tools
vim.keymap.set('n', '<leader>or', '<cmd>Obsidian rename<cr>', { desc = 'Obsidian: Rename note & references' })
vim.keymap.set('n', '<leader>oi', '<cmd>Obsidian paste_img<cr>', { desc = 'Obsidian: Paste clipboard image' })

-- Visual mode
vim.keymap.set('v', '<leader>ol', ':<C-u>Obsidian link<cr>', { desc = 'Obsidian: Link selection to note' })
vim.keymap.set('v', '<leader>on', ':<C-u>Obsidian link_new<cr>', { desc = 'Obsidian: Link selection to new note' })
vim.keymap.set('v', '<leader>oe', ':<C-u>Obsidian extract_note<cr>', { desc = 'Obsidian: Extract selection to new note' })
