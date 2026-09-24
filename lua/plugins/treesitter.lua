-- ============================================================================
-- TREESITTER
-- Parser installation, syntax highlighting, folds, indentation
-- ============================================================================

local gh = require('core.utils').gh

-- [[ Configure Treesitter ]]
--  Used to highlight, edit, and navigate code
--
--  See `:help nvim-treesitter-intro`

-- NOTE: You can also specify a branch or a specific commit
vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

-- Ensure basic parsers are installed
local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
require('nvim-treesitter').install(parsers)

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
  -- Check if a parser exists and load it
  if not vim.treesitter.language.add(language) then return end
  -- Enable syntax highlighting and other treesitter features
  vim.treesitter.start(buf, language)

  -- Enable treesitter based folds
  -- For more info on folds see `:help folds`
  -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  -- vim.wo.foldmethod = 'expr'

  -- Check if treesitter indentation is available for this language, and if so enable it
  -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
  local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

  -- Disable treesitter indent for C/C++ — its `align` query triggers on ERROR nodes
  -- (e.g. incomplete `ans[i] =` while typing) and returns absolute indent `o_scol+1` = 9,
  -- which causes `o`/`O`/`<CR>` after `vector<int> ans(...);` to jump to 8-9 spaces
  -- instead of `shiftwidth` (2). Fall back to native `cindent` which respects `shiftwidth`.
  local ts_indent_exclude = { c = true, cpp = true }
  if has_indent_query and not ts_indent_exclude[language] then
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  elseif ts_indent_exclude[language] then
    vim.bo.indentexpr = ''
    vim.bo.cindent = true
    -- Keep `public:`/`private:` at class scope (0) like treesitter did, not `shiftwidth`
    if not vim.bo.cinoptions:find('g0') then
      vim.bo.cinoptions = vim.bo.cinoptions == '' and 'g0' or vim.bo.cinoptions .. ',g0'
    end
    -- Use Neovim's built-in C indent; `lisp`/`smartindent` would interfere
    vim.bo.lisp = false
    vim.bo.smartindent = false
  end
end

local available_parsers = require('nvim-treesitter').get_available()
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, filetype = args.buf, args.match

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then return end

    local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

    if vim.tbl_contains(installed_parsers, language) then
      -- Enable the parser if it is already installed
      treesitter_try_attach(buf, language)
    elseif vim.tbl_contains(available_parsers, language) then
      -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
      require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
    else
      -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
      treesitter_try_attach(buf, language)
    end
  end,
})
