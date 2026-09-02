local gh = require('core.utils').gh

-- [[ Bufferline (Tabs) ]]
-- https://github.com/akinsho/bufferline.nvim
vim.pack.add { gh 'akinsho/bufferline.nvim' }

require("bufferline").setup {
  options = {
    mode = "buffers", -- set to "tabs" to only show tabpages instead
    numbers = "none",
    close_command = "bdelete! %d",
    right_mouse_command = "bdelete! %d",
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    indicator = {
      icon = '▎', -- this should be omitted if indicator style is not 'icon'
      style = 'icon',
    },
    buffer_close_icon = '󰅖',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 18,
    max_prefix_length = 15,
    truncate_names = true,
    tab_size = 18,
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "center",
        separator = true
      }
    },
    color_icons = true,
    show_buffer_icons = vim.g.have_nerd_font,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    persist_buffer_sort = true,
    separator_style = "thin",
    enforce_regular_tabs = false,
    always_show_bufferline = false,
    hover = {
      enabled = true,
      delay = 200,
      reveal = {'close'}
    }
  }
}

-- Keymaps for buffer navigation
vim.keymap.set('n', '<S-h>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Go to previous buffer' })
vim.keymap.set('n', '<S-l>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Go to next buffer' })
vim.keymap.set('n', '<leader>x', '<Cmd>bdelete<CR>', { desc = 'Close buffer' })
