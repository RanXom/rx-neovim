-- ============================================================================
-- MARKDOWN RENDERING
-- render-markdown.nvim: rich markdown display in the buffer
-- ============================================================================

local gh = require('core.utils').gh

vim.pack.add { gh 'MeanderingProgrammer/render-markdown.nvim' }

require('render-markdown').setup {
  -- Render markdown in ALL modes (including Insert mode)
  render_modes = true,
  
  -- Disable built-in LaTeX unicode rendering.
  -- render-latex.nvim handles display math as images with higher fidelity.
  latex = {
    enabled = false,
  },
}

-- ============================================================================
-- HOTFIX: render-markdown async treesitter out-of-bounds error
-- This intercepts the plugin's internal Node creation to safely pcall the
-- text retrieval. This guarantees it survives plugin updates and clones!
-- ============================================================================
vim.schedule(function()
  local ok, node_lib = pcall(require, 'render-markdown.lib.node')
  if ok and type(node_lib) == 'table' and node_lib.new then
    local orig_new = node_lib.new
    node_lib.new = function(buf, node)
      -- Instead of calling orig_new (which crashes on get_node_text), we recreate the
      -- instantiation safely, handling the out-of-bounds race condition.
      local self = setmetatable({}, node_lib)
      self.buf = buf
      self.node = node
      self.type = node:type()
      
      -- SAFE TEXT RETRIEVAL
      local success, text = pcall(vim.treesitter.get_node_text, node, buf)
      self.text = success and (text or "") or ""
      
      local start_row, start_col, end_row, end_col = node:range()
      self.start_row = start_row
      self.start_col = start_col
      self.end_row = end_row
      self.end_col = end_col
      return self
    end
  end
end)
