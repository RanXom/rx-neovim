-- autopairs
-- https://github.com/windwp/nvim-autopairs

local gh = require('core.utils').gh
vim.pack.add { gh 'windwp/nvim-autopairs' }
local autopairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')

autopairs.setup {}

-- Add < > pair specifically as requested, but make it smart so it doesn't break C++ cout <<
autopairs.add_rule(
  Rule('<', '>')
    :with_pair(function(opts)
      -- Always allow in HTML-like files
      if vim.tbl_contains({ 'html', 'xml', 'javascriptreact', 'typescriptreact', 'vue', 'svelte' }, vim.bo.filetype) then
        return true
      end
      
      -- For C++/Rust: only pair if it looks like a template (after a word) or an include
      local last_char = opts.line:sub(opts.col - 1, opts.col - 1)
      if last_char:match('[%w%_]') then return true end
      if opts.line:sub(1, opts.col - 1):match('#include%s*$') then return true end
      
      -- Otherwise, don't auto-pair (prevents breaking `cout <<` or `if (a < b)`)
      return false
    end)
)
