-- ============================================================================
-- LATEX RENDERING
-- render-latex.nvim: display math rendered as images via Kitty graphics
-- ============================================================================
--
-- Renders $$...$$ and \[...\] display math blocks as transparent PNG images.
-- Inline math ($x^2$) is handled via conceal/highlight fallback.
-- Uses a persistent Rust worker (auto-installed prebuilt binary).
--
-- Requirements:
--   - Neovim 0.10+
--   - Kitty graphics-compatible terminal (Kitty, Ghostty, WezTerm)
--   - Prebuilt worker auto-downloads on first load
--   - For tmux: set -g allow-passthrough on
--
-- Useful commands:
--   :RenderLatex doctor     -- diagnostics
--   :RenderLatex install    -- download worker binary
--   :RenderLatex refresh    -- re-render current buffer

local gh = require('core.utils').gh

vim.pack.add { gh 'techwizrd/render-latex.nvim' }

require('render_latex').setup {
  render = {
    preset = 'match_text', -- 'compact' or 'presentation'
    inline = 'conceal', -- 'content', 'highlight', or false
    inline_symbols = true,
    live_preview = true,
  },
}
