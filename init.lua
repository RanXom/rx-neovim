-- [[ init.lua ]]
-- Neovim initialization file

require 'core.options'
require 'core.keymaps'
require 'core.autocmds'

require 'plugins.lazy'
require 'plugins.ui'
require 'plugins.completion'
require 'plugins.autopairs'
require 'plugins.formatting'
require 'plugins.telescope'
require 'plugins.treesitter'
require 'plugins.lsp'
require 'plugins.comments'
require 'plugins.markdown'
require 'plugins.image'
require 'plugins.latex'
require 'plugins.cmdline_ui'
require 'plugins.snacks'
require 'plugins.tree'
require 'plugins.indent'
require 'plugins.bufferline'
require 'plugins.web-tools'

-- ============================================================
-- Optional Kickstart modules
-- ============================================================
-- require 'kickstart.plugins.debug'
-- require 'kickstart.plugins.lint'
