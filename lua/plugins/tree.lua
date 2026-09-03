local gh = require('core.utils').gh

-- [[ File Explorer ]]
-- https://github.com/nvim-tree/nvim-tree.lua
vim.pack.add { gh 'nvim-tree/nvim-tree.lua' }
local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end
  api.config.mappings.default_on_attach(bufnr)
  vim.keymap.set('n', '<Space>', api.node.open.edit, opts('Open'))
end

require("nvim-tree").setup {
  on_attach = my_on_attach,
  view = {
    width = 30,
    relativenumber = false,
    number = false,
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
