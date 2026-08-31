 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#111318',
    base01 = '#1d2024',
    base02 = '#282a2f',
    base03 = '#8e9099',
    base04 = '#c4c6cf',
    base05 = '#e2e2e9',
    base06 = '#e2e2e9',
    base07 = '#e2e2e9',
    base08 = '#ffb4ab',
    base09 = '#dcbce1',
    base0A = '#bdc7dc',
    base0B = '#a9c7ff',
    base0C = '#dcbce1',
    base0D = '#a9c7ff',
    base0E = '#bdc7dc',
    base0F = '#d9e3f9',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#e2e2e9',          bg = '#111318' })
  hi('TelescopeBorder',         { fg = '#8e9099',             bg = '#111318' })
  hi('TelescopePromptNormal',   { fg = '#e2e2e9',          bg = '#111318' })
  hi('TelescopePromptBorder',   { fg = '#8e9099',             bg = '#111318' })
  hi('TelescopePromptPrefix',   { fg = '#a9c7ff',             bg = '#111318' })
  hi('TelescopePromptCounter',  { fg = '#c4c6cf',  bg = '#111318' })
  hi('TelescopePromptTitle',    { fg = '#111318',             bg = '#a9c7ff' })
  hi('TelescopePreviewTitle',   { fg = '#111318',             bg = '#bdc7dc' })
  hi('TelescopeResultsTitle',   { fg = '#111318',             bg = '#dcbce1' })
  hi('TelescopeSelection',      { fg = '#e2e2e9',          bg = '#282a2f' })
  hi('TelescopeSelectionCaret', { fg = '#a9c7ff',             bg = '#282a2f' })
  hi('TelescopeMatching',       { fg = '#a9c7ff',             bold = true })
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
