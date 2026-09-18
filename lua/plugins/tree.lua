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
  hijack_directories = {
    enable = false,
  },
  view = {
    width = 30,
    relativenumber = false,
    number = false,
  },
  filters = {
    dotfiles = true,
    git_ignored = true,
    custom = { "^\\.git$" },
  },
  git = {
    enable = true,
  },
  renderer = {
    root_folder_label = false,
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

-- Open empty buffer alongside nvim-tree when opening a directory (e.g. `nvim .`)
local function open_nvim_tree(data)
  local directory = vim.fn.isdirectory(data.file) == 1
  if not directory then
    return
  end

  -- create a new, empty buffer
  vim.cmd.enew()

  -- wipe the directory buffer
  vim.cmd.bw(data.buf)

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = open_nvim_tree,
  desc = "Open empty buffer alongside nvim-tree on directory open",
})

-- Toggle nvim-tree with <leader>e
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle File [E]xplorer', silent = true })
