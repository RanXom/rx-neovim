-- autopairs
-- https://github.com/windwp/nvim-autopairs

local gh = require('core.utils').gh
vim.pack.add { gh 'windwp/nvim-autopairs' }
require('nvim-autopairs').setup {}
