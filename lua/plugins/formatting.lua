-- ============================================================================
-- FORMATTING
-- conform.nvim setup and keymap
-- ============================================================================

local gh = require('core.utils').gh

-- [[ Formatting ]]
vim.pack.add { gh 'stevearc/conform.nvim' }
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return nil
    end

    -- Disable autoformat on save for markdown files by default (avoids messing up Obsidian notes/templates)
    -- You can still manually format any buffer with <leader>f
    local ignore_filetypes = { markdown = true }
    if ignore_filetypes[vim.bo[bufnr].filetype] then
      return nil
    end

    return {
      timeout_ms = 1000,
      lsp_format = 'fallback',
    }
  end,
  default_format_opts = {
    lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting.
  },
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'black' },
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    typescript = { 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    html = { 'prettierd', 'prettier', stop_after_first = true },
    css = { 'prettierd', 'prettier', stop_after_first = true },
    scss = { 'prettierd', 'prettier', stop_after_first = true },
    json = { 'prettierd', 'prettier', stop_after_first = true },
    jsonc = { 'prettierd', 'prettier', stop_after_first = true },
    yaml = { 'prettierd', 'prettier', stop_after_first = true },
    c = { 'clang-format' },
    cpp = { 'clang-format' },
  },
}

-- Keymap to manually format buffer
vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]ormat buffer' })

-- Keymap to toggle autoformat on save
vim.keymap.set('n', '<leader>tf', function()
  vim.b.disable_autoformat = not vim.b.disable_autoformat
  local status = vim.b.disable_autoformat and 'disabled' or 'enabled'
  vim.notify('Format-on-save ' .. status .. ' for this buffer', vim.log.levels.INFO)
end, { desc = '[T]oggle [F]ormat on save (buffer)' })

-- Commands to toggle autoformat on save
vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    vim.g.disable_autoformat = true
    vim.notify('Format-on-save disabled globally', vim.log.levels.WARN)
  else
    vim.b.disable_autoformat = true
    vim.notify('Format-on-save disabled for current buffer', vim.log.levels.WARN)
  end
end, {
  desc = 'Disable autoformat-on-save (use ! for global)',
  bang = true,
})

vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
  vim.notify('Format-on-save enabled', vim.log.levels.INFO)
end, {
  desc = 'Re-enable autoformat-on-save',
})
