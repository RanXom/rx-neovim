-- autopairs
-- https://github.com/windwp/nvim-autopairs

local gh = require('core.utils').gh
vim.pack.add { gh 'windwp/nvim-autopairs' }
local autopairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')

autopairs.setup {}

-- Add < > pair specifically as requested by the user
autopairs.add_rule(Rule('<', '>'))
