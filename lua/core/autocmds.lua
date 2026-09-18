-- ============================================================================
-- AUTOCMDS
-- ============================================================================

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Natively enforce 2-space indentation for web/config languages
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Set 2-space indent for web and config files',
  group = vim.api.nvim_create_augroup('set-indent-2', { clear = true }),
  pattern = { 'html', 'css', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json', 'yaml', 'lua', 'markdown' },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- Natively enforce 4-space indentation for systems/backend languages
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Set 4-space indent for systems and backend files',
  group = vim.api.nvim_create_augroup('set-indent-4', { clear = true }),
  pattern = { 'c', 'cpp', 'rust', 'python', 'java', 'go' },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = true
  end,
})

-- Enable spell checking for markdown and text files
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Enable spell checking for text files',
  group = vim.api.nvim_create_augroup('enable-spellcheck', { clear = true }),
  pattern = { 'markdown', 'text', 'txt' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en_us'
  end,
})

-- gopass security hardening (NixOS/Linux: gopass uses /dev/shm for temp files)
-- Prevents Neovim from leaking password data via swap, backup, undo, or shada files.
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  desc = 'Disable all persistence for gopass secrets',
  group = vim.api.nvim_create_augroup('gopass-hardening', { clear = true }),
  pattern = '/dev/shm/gopass*',
  callback = function()
    vim.opt_local.swapfile = false
    vim.opt_local.backup = false
    vim.opt_local.undofile = false
    vim.opt_local.shadafile = 'NONE'
  end,
})
