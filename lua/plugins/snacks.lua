-- ============================================================================
-- SNACKS.NVIM
-- A collection of QoL plugins for Neovim (Dashboard, etc.)
-- ============================================================================

local gh = require('core.utils').gh

vim.pack.add { gh 'folke/snacks.nvim' }

require("snacks").setup({
  dashboard = {
    enabled = true,
    -- Customize your dashboard here. 
    -- Example presets or configurations can be changed below.
    preset = {
      -- You can change the header text, art, or keys here:
      header = [[
    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]],
      -- Example custom keys
      -- keys = {
      --   { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
      --   { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
      --   { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
      --   { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
      --   { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      -- },
    },
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
    },
  },
})
