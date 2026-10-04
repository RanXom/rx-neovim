-- ============================================================
-- Version requirements
-- ============================================================
-- Everything below is built on `vim.pack` (the plugin manager and
-- the `PackChanged` autocmd event), which requires Neovim 0.12+.
-- Fail fast with a clear message instead of a confusing runtime
-- error like `E5113: Invalid 'event': 'PackChanged'`.
if vim.fn.has('nvim-0.12') ~= 1 then
  error(('rx-neovim requires Neovim 0.12 or newer (found v%s). Install a recent Neovim and try again.'):format(vim.version().version))
end

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
require 'plugins.snacks'
require 'plugins.cmdline_ui'
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
-- Preferred: matugen-generated base16 palette. Fallback: catppuccin-mocha.
-- The fallback covers fresh clones (plugins not yet installed), offline
-- systems, and minimal installs (Termux/Ubuntu) where base16 failed.
local applied = false
local ok, matugen = pcall(require, 'matugen')
if ok then
  local setup_ok, result = pcall(matugen.setup)
  applied = setup_ok and result ~= false
end

if not applied then
  local ok_cat, catppuccin = pcall(require, 'catppuccin')
  if ok_cat then
    pcall(catppuccin.setup, { flavour = 'mocha' })
    pcall(vim.cmd.colorscheme, 'catppuccin-mocha')
  else
    -- Last resort: built-in scheme so we never boot with no colors.
    pcall(vim.cmd.colorscheme, 'habamax')
  end
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
