-- ============================================================================
-- IMAGE RENDERING
-- image.nvim: display images inline using Kitty graphics protocol
-- ============================================================================
--
-- System dependencies:
--   - ImageMagick (the `magick` CLI must be in $PATH)
--   - Kitty terminal (or Ghostty/WezTerm with Kitty graphics support)
--   - curl (for downloading remote images)
--
-- Install on NixOS:  imagemagick, curl in environment.systemPackages
-- Install on Arch:   sudo pacman -S imagemagick curl
-- Install on Ubuntu: sudo apt install imagemagick curl

local gh = require('core.utils').gh

vim.pack.add { gh '3rd/image.nvim' }

require('image').setup {
  backend = 'kitty',
  processor = 'magick_cli', -- Use ImageMagick CLI directly (avoids luarocks magick FFI issues)

  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      filetypes = { 'markdown', 'vimwiki' },
    },
  },

  -- Size constraints
  max_width = nil,
  max_height = nil,
  max_width_window_percentage = nil,
  max_height_window_percentage = 50,

  -- Kitty-specific
  kitty_method = 'normal',

  -- Clear images when floating windows (cmp, telescope, which-key) overlap
  window_overlap_clear_enabled = true,
  window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },

  -- Hijack file patterns to render images when opened directly
  hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' },
}
