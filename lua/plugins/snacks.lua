-- ============================================================================
-- SNACKS.NVIM
-- A collection of QoL plugins for Neovim (Dashboard, etc.)
-- ============================================================================

local gh = require('core.utils').gh

vim.pack.add { gh 'folke/snacks.nvim' }

require("snacks").setup({
  notifier = {
    enabled = true,
    timeout = 3000,
  },
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

-- snacks.dashboard forces the statusline to hide (laststatus = 0).
-- We force it back to 3 whenever the dashboard opens.
vim.api.nvim_create_autocmd("User", {
  pattern = "SnacksDashboardOpened",
  callback = function()
    vim.o.laststatus = 3
  end,
})
