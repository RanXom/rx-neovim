-- ============================================================================
-- OBSIDIAN
-- Obsidian vault integration: wiki-links, backlinks, daily notes, search
-- ============================================================================

local gh = require('core.utils').gh

vim.pack.add { { src = gh 'obsidian-nvim/obsidian.nvim', version = vim.version.range '3.*' } }

-- Only register workspaces whose path exists on this machine.
-- obsidian.nvim throws E5113 ("Please specify a valid workspace") when
-- every workspace path is missing (e.g. Termux/phone without the vault
-- synced), which would abort the rest of init.lua. Skip setup instead.
local candidate_workspaces = {
  {
    name = 'Lessons',
    path = '~/Documents/Obsidian/Lessons',
  },
}

local workspaces = {}
for _, ws in ipairs(candidate_workspaces) do
  local expanded = vim.fn.expand(ws.path)
  if vim.fn.isdirectory(expanded) == 1 then
    table.insert(workspaces, ws)
  end
end

if #workspaces == 0 then
  vim.schedule(function()
    vim.notify(
      'obsidian: no vault path exists on this machine, skipping setup. Sync your vault to enable it.',
      vim.log.levels.INFO
    )
  end)
  return
end

local setup_ok, err = pcall(require('obsidian').setup, {
  workspaces = workspaces,

  picker = {
    name = 'telescope.nvim',
    note_mappings = {
      new = "<C-x>",
      insert_link = "<C-l>",
    },
  },

  notes_subdir = "6 - Main Notes",

  templates = {
    subdir = "5 - Templates",
    date_format = "%d-%m-%Y %H:%M %p",
    time_format = "%H:%M",
  },

  frontmatter = {
    enabled = false,
    -- Fallback: even if obsidian's rename path bypasses `enabled`,
    -- return an empty table so no keys are written.
    func = function(_) return {} end,
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
})

if not setup_ok then
  vim.schedule(function()
    vim.notify('obsidian: setup failed: ' .. tostring(err), vim.log.levels.WARN)
  end)
  return
end

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
