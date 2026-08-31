-- ============================================================================
-- MARKDOWN RENDERING
-- render-markdown.nvim: rich markdown display in the buffer
-- ============================================================================

local gh = require('core.utils').gh

vim.pack.add { gh 'MeanderingProgrammer/render-markdown.nvim' }

require('render-markdown').setup {
  -- Disable built-in LaTeX unicode rendering.
  -- render-latex.nvim handles display math as images with higher fidelity.
  latex = {
    enabled = false,
  },
}
