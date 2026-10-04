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
-- Theme first: apply before any plugin loads so a later plugin
-- error (e.g. obsidian on Termux) can never leave us colorless.
-- Preferred: matugen-generated base16 palette.
-- Fallback: catppuccin-mocha, then built-in habamax.
-- ============================================================
-- Bootstrap theme plugins here (idempotent with plugins/ui.lua) so the
-- fallback works even on a fresh clone before plugins.ui has run.
pcall(vim.pack.add, {
  'https://github.com/RRethy/base16-nvim',
  'https://github.com/catppuccin/nvim',
})

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
    applied = pcall(vim.cmd.colorscheme, 'catppuccin-mocha')
  end
end

if not applied then
  -- Last resort: built-in scheme so we never boot with no colors.
  pcall(vim.cmd.colorscheme, 'habamax')
end

-- ============================================================
-- Plugins (each isolated: one failing plugin can't abort startup)
-- ============================================================
local function plug(name)
  local ok_mod, err = pcall(require, name)
  if not ok_mod then
    vim.schedule(function()
      vim.notify(('config: %s failed: %s'):format(name, tostring(err)), vim.log.levels.WARN)
    end)
  end
end

plug 'plugins.snacks'
plug 'plugins.cmdline_ui'
plug 'plugins.ui'
plug 'plugins.telescope'
plug 'plugins.lsp'
plug 'plugins.formatting'
plug 'plugins.completion'
plug 'plugins.treesitter'
plug 'plugins.obsidian'
plug 'plugins.markdown'
plug 'plugins.image'
plug 'plugins.latex'
plug 'plugins.tree'
plug 'plugins.indent'
plug 'plugins.bufferline'
plug 'plugins.web-tools'

-- ============================================================
-- Optional Kickstart modules
-- Uncomment any of the lines below to enable them.
-- ============================================================
-- require 'kickstart.plugins.debug'
-- require 'kickstart.plugins.indent_line'
-- require 'kickstart.plugins.lint'
plug 'plugins.autopairs'
-- require 'kickstart.plugins.neo-tree'
-- require 'kickstart.plugins.gitsigns' -- adds gitsigns recommended keymaps

-- NOTE: You can add your own plugins to `lua/custom/plugins/*.lua`
-- require 'custom.plugins'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
