-- ============================================================================
-- WEB TOOLS
-- ray-x/web-tools.nvim: Live Server, Hurl (HTTP requests), CSS colors
-- ============================================================================

local gh = require('core.utils').gh

vim.pack.add {
  gh 'ray-x/guihua.lua', -- Required dependency for web-tools
  gh 'ray-x/web-tools.nvim',
}

require('web-tools').setup {
  keymaps = {
    rename = nil,
    repeat_rename = '.',
  },
  hurl = {
    show_headers = false,
    floating = true,
    formatters = {
      json = { 'jq' },
      html = { 'prettier', '--parser', 'html' },
    },
  },
}
