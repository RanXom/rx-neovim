 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#111318',
    base01 = '#1d2024',
    base02 = '#282a2f',
    base03 = '#8d9199',
    base04 = '#c3c6cf',
    base05 = '#e1e2e9',
    base06 = '#e1e2e9',
    base07 = '#e1e2e9',
    base08 = '#ffb4ab',
    base09 = '#d9bde2',
    base0A = '#bcc7dc',
    base0B = '#a5c8fe',
    base0C = '#d9bde2',
    base0D = '#a5c8fe',
    base0E = '#bcc7dc',
    base0F = '#d8e3f8',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#e1e2e9',          bg = '#111318' })
  hi('TelescopeBorder',         { fg = '#8d9199',             bg = '#111318' })
  hi('TelescopePromptNormal',   { fg = '#e1e2e9',          bg = '#111318' })
  hi('TelescopePromptBorder',   { fg = '#8d9199',             bg = '#111318' })
  hi('TelescopePromptPrefix',   { fg = '#a5c8fe',             bg = '#111318' })
  hi('TelescopePromptCounter',  { fg = '#c3c6cf',  bg = '#111318' })
  hi('TelescopePromptTitle',    { fg = '#111318',             bg = '#a5c8fe' })
  hi('TelescopePreviewTitle',   { fg = '#111318',             bg = '#bcc7dc' })
  hi('TelescopeResultsTitle',   { fg = '#111318',             bg = '#d9bde2' })
  hi('TelescopeSelection',      { fg = '#e1e2e9',          bg = '#282a2f' })
  hi('TelescopeSelectionCaret', { fg = '#a5c8fe',             bg = '#282a2f' })
  hi('TelescopeMatching',       { fg = '#a5c8fe',             bold = true })
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
