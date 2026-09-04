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
