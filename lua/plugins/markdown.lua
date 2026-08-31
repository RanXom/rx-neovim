-- ============================================================================
-- MARKDOWN RENDERING
-- render-markdown.nvim: rich markdown display in the buffer
-- ============================================================================

local gh = require('core.utils').gh

vim.pack.add { gh 'MeanderingProgrammer/render-markdown.nvim' }

require('render-markdown').setup {
  -- LaTeX math rendering (Unicode-based via latex2text / utftex)
  -- Requires: pip install pylatexenc (for latex2text)
  -- or: libtexprintf package (for utftex)
  latex = {
    enabled = true,
    converter = { 'latex2text', 'utftex' },
    highlight = 'RenderMarkdownMath',
  },
}
