-- ============================================================================
-- COMPLETION & SNIPPETS
-- blink.cmp and LuaSnip setup
-- ============================================================================

local gh = require('core.utils').gh

-- [[ Snippet Engine ]]

-- NOTE: You can also specify plugin using a version range for its git tag.
--  See `:help vim.version.range()` for more info
vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
require('luasnip').setup {}

-- `friendly-snippets` contains a variety of premade snippets.
--    See the README about individual language/framework/plugin snippets:
--    https://github.com/rafamadriz/friendly-snippets
--
vim.pack.add { gh 'rafamadriz/friendly-snippets' }
require('luasnip.loaders.from_vscode').lazy_load()

-- [[ Autocomplete Engine ]]
vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
require('blink.cmp').setup {
  keymap = {
    -- We use 'none' preset so we can define exactly what we want without overlap
    preset = 'none',
    
    -- Accept the current selection with Enter
    ['<CR>'] = { 'accept', 'fallback' },
    
    -- Cycle through autocomplete options with Tab and Shift-Tab (and jump through snippets)
    ['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
    ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
    
    -- Keep standard arrow keys and C-n/C-p as alternatives
    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
    ['<C-p>'] = { 'select_prev', 'fallback' },
    ['<C-n>'] = { 'select_next', 'fallback' },
    
    -- Other useful defaults
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-e>'] = { 'hide' },
  },

  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'mono',
  },

  completion = {
    menu = {
      draw = {
        -- Right-aligned 'source' column: 'label' fills the middle (default
        -- width.fill), pushing the item's source (file path / module) to the
        -- right edge so you can tell which file each suggestion comes from.
        columns = {
          { 'kind_icon' },
          { 'label', gap = 1 },
          { 'source' },
        },
        components = {
          source = {
            width = { max = 45 },
            text = function(ctx)
              -- clangd ships the symbol's file as "From `header.h`" at the top
              -- of the item documentation (only when it offers an include).
              -- NOTE: ctx.label_description is '' (not nil) for clangd, so it
              -- cannot be used to short-circuit a fallback chain.
              local doc = ctx.item.documentation
              if type(doc) == 'table' then doc = doc.value end
              if type(doc) == 'string' then
                local from = doc:match("^[Ff]rom `?([^`%s]+)`?")
                if from then return from end
              end
              -- clangd records the header in additionalTextEdits; gopls adds
              -- unimported packages as `import "pkg"` edits the same way.
              if type(ctx.item.additionalTextEdits) == 'table' then
                for _, edit in ipairs(ctx.item.additionalTextEdits) do
                  local edit_text = edit.newText or ''
                  local header = edit_text:match('#include%s*[<"]([^>"]+)')
                    or edit_text:match('%f[%w]import%s*[<"]([^>"]+)')
                    or edit_text:match('%f[%w]from%s*["]([^"]+)')
                  if header then return header end
                end
              end
              -- TS/rust-analyzer put the module/namespace path here
              if ctx.label_description ~= '' then return ctx.label_description end
              -- clangd sends nothing more for symbols already in the TU: fall
              -- back to the item type (e.g. `int`) rather than the generic
              -- provider name, so rows remain distinguishable.
              if ctx.item.detail and ctx.item.detail ~= '' then return ctx.item.detail end
              -- Last resort: provider name (LSP / Path / Snippets)
              return ctx.source_name
            end,
            highlight = 'BlinkCmpSource',
          },
        },
      },
    },
    -- By default, you may press `<c-space>` to show the documentation.
    -- Optionally, set `auto_show = true` to show the documentation after a delay.
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets' },
  },

  snippets = { preset = 'luasnip' },

  -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
  -- which automatically downloads a prebuilt binary when enabled.
  --
  -- By default, we use the Lua implementation instead, but you may enable
  -- the rust implementation via `'prefer_rust_with_warning'`
  --
  -- See `:help blink-cmp-config-fuzzy` for more information
  fuzzy = { implementation = 'lua' },

  -- Shows a signature help window while you type arguments for a function
  signature = { enabled = true },
}
