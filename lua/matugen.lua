 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#1a1112',
    base01 = '#271d1e',
    base02 = '#322828',
    base03 = '#9f8c8c',
    base04 = '#d7c1c2',
    base05 = '#f0dede',
    base06 = '#f0dede',
    base07 = '#f0dede',
    base08 = '#ffb4ab',
    base09 = '#e7c08e',
    base0A = '#e6bdbe',
    base0B = '#ffb2b6',
    base0C = '#e7c08e',
    base0D = '#ffb2b6',
    base0E = '#e6bdbe',
    base0F = '#ffdadb',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f0dede',          bg = '#1a1112' })
  hi('TelescopeBorder',         { fg = '#9f8c8c',             bg = '#1a1112' })
  hi('TelescopePromptNormal',   { fg = '#f0dede',          bg = '#1a1112' })
  hi('TelescopePromptBorder',   { fg = '#9f8c8c',             bg = '#1a1112' })
  hi('TelescopePromptPrefix',   { fg = '#ffb2b6',             bg = '#1a1112' })
  hi('TelescopePromptCounter',  { fg = '#d7c1c2',  bg = '#1a1112' })
  hi('TelescopePromptTitle',    { fg = '#1a1112',             bg = '#ffb2b6' })
  hi('TelescopePreviewTitle',   { fg = '#1a1112',             bg = '#e6bdbe' })
  hi('TelescopeResultsTitle',   { fg = '#1a1112',             bg = '#e7c08e' })
  hi('TelescopeSelection',      { fg = '#f0dede',          bg = '#322828' })
  hi('TelescopeSelectionCaret', { fg = '#ffb2b6',             bg = '#322828' })
  hi('TelescopeMatching',       { fg = '#ffb2b6',             bold = true })
end

-- Register a signal handler for SIGUSR1 (matugen updates).
-- The handler re-requires this module, which re-runs the code below, so the
-- previous handle is stopped first; otherwise handlers double on every signal.
if _G.__matugen_signal then
  _G.__matugen_signal:stop()
  _G.__matugen_signal:close()
end

local signal = vim.uv.new_signal()
_G.__matugen_signal = signal
signal:start(
  'sigusr1',
  vim.schedule_wrap(function()
    package.loaded['matugen'] = nil
    require('matugen').setup()
  end)
)

return M
