local gh = require('core.utils').gh

-- [[ File Explorer ]]
-- https://github.com/nvim-tree/nvim-tree.lua
vim.pack.add { gh 'nvim-tree/nvim-tree.lua' }
require("nvim-tree").setup {
  view = {
    width = 30,
    relativenumber = true,
  },
  filters = {
    dotfiles = false,
  },
  git = {
    enable = true,
    ignore = false,
  },
  renderer = {
    icons = {
      show = {
        file = vim.g.have_nerd_font,
        folder = vim.g.have_nerd_font,
        folder_arrow = vim.g.have_nerd_font,
        git = true,
      },
    },
  },
}

-- Toggle nvim-tree with <leader>e
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle File [E]xplorer', silent = true })
