 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#11140f',
    base01 = '#1d211b',
    base02 = '#272b25',
    base03 = '#8d9387',
    base04 = '#c3c8bc',
    base05 = '#e1e4da',
    base06 = '#e1e4da',
    base07 = '#e1e4da',
    base08 = '#ffb4ab',
    base09 = '#a0cfd2',
    base0A = '#bbcbb1',
    base0B = '#a6d395',
    base0C = '#a0cfd2',
    base0D = '#a6d395',
    base0E = '#bbcbb1',
    base0F = '#d7e8cc',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#e1e4da',          bg = '#11140f' })
  hi('TelescopeBorder',         { fg = '#8d9387',             bg = '#11140f' })
  hi('TelescopePromptNormal',   { fg = '#e1e4da',          bg = '#11140f' })
  hi('TelescopePromptBorder',   { fg = '#8d9387',             bg = '#11140f' })
  hi('TelescopePromptPrefix',   { fg = '#a6d395',             bg = '#11140f' })
  hi('TelescopePromptCounter',  { fg = '#c3c8bc',  bg = '#11140f' })
  hi('TelescopePromptTitle',    { fg = '#11140f',             bg = '#a6d395' })
  hi('TelescopePreviewTitle',   { fg = '#11140f',             bg = '#bbcbb1' })
  hi('TelescopeResultsTitle',   { fg = '#11140f',             bg = '#a0cfd2' })
  hi('TelescopeSelection',      { fg = '#e1e4da',          bg = '#272b25' })
  hi('TelescopeSelectionCaret', { fg = '#a6d395',             bg = '#272b25' })
  hi('TelescopeMatching',       { fg = '#a6d395',             bold = true })
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
