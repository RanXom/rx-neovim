-- ============================================================
-- Core
-- ============================================================
require 'core.options'
require 'core.keymaps'
require 'core.autocmds'
require 'core.plugin-events'

-- ============================================================
-- Plugins
-- ============================================================
require 'plugins.ui'
require 'plugins.telescope'
require 'plugins.lsp'
require 'plugins.formatting'
require 'plugins.completion'
require 'plugins.treesitter'
require 'plugins.obsidian'
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
-- Uncomment any of the lines below to enable them.
-- ============================================================
-- require 'kickstart.plugins.debug'
-- require 'kickstart.plugins.indent_line'
-- require 'kickstart.plugins.lint'
require 'plugins.autopairs'
-- require 'kickstart.plugins.neo-tree'
-- require 'kickstart.plugins.gitsigns' -- adds gitsigns recommended keymaps

-- NOTE: You can add your own plugins to `lua/custom/plugins/*.lua`
-- require 'custom.plugins'

-- ============================================================
-- Integrations
-- ============================================================
local ok, matugen = pcall(require, 'matugen')
if ok then matugen.setup() end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
