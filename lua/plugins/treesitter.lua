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

-- Portable parser installation: needs a C compiler + git/tar.
-- Missing toolchain (fresh Ubuntu, Termux without `pkg install clang`)
-- must degrade to vim syntax instead of erroring on startup.
local function exe(bin) return vim.fn.executable(bin) == 1 end

local has_compiler = exe 'cc' or exe 'gcc' or exe 'clang'
local has_downloader = exe 'git' or exe 'curl' or exe 'wget'
local can_build_parsers = has_compiler and has_downloader

if not can_build_parsers then
  local missing = {}
  if not has_compiler then table.insert(missing, 'C compiler (cc/gcc/clang)') end
  if not has_downloader then table.insert(missing, 'git/curl/wget') end
  vim.schedule(function()
    vim.notify(
      'treesitter: skipping parser install (missing ' .. table.concat(missing, ', ') .. '). '
        .. 'Install a compiler to enable highlighting. Termux: `pkg install clang git`. Ubuntu: `sudo apt install build-essential git`.',
      vim.log.levels.WARN
    )
  end)
else
  -- Ensure basic parsers are installed
  local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
  pcall(require('nvim-treesitter').install, parsers)
end

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
  -- pcall: language.add / start throw when the parser .so is missing.
  -- Never let a missing parser kill the FileType autocmd chain.
  local add_ok, added = pcall(vim.treesitter.language.add, language)
  if not add_ok or not added then return end
  local start_ok = pcall(vim.treesitter.start, buf, language)
  if not start_ok then return end

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

local available_parsers = {}
pcall(function() available_parsers = require('nvim-treesitter').get_available() end)
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, filetype = args.buf, args.match

    local lang_ok, language = pcall(vim.treesitter.language.get_lang, filetype)
    if not lang_ok or not language then return end

    local installed_ok, installed_parsers = pcall(require('nvim-treesitter').get_installed, 'parsers')
    if not installed_ok then
      installed_parsers = {}
    end

    if vim.tbl_contains(installed_parsers, language) then
      -- Enable the parser if it is already installed
      treesitter_try_attach(buf, language)
    elseif can_build_parsers and vim.tbl_contains(available_parsers, language) then
      -- Auto-install only when we can actually compile. Otherwise fall
      -- back to vim syntax silently (startup already warned once).
      local install_ok, handle = pcall(require('nvim-treesitter').install, language)
      if install_ok and handle and handle.await then
        handle:await(function() treesitter_try_attach(buf, language) end)
      end
    else
      -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
      treesitter_try_attach(buf, language)
    end
  end,
})
