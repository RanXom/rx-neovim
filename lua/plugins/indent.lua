local gh = require('core.utils').gh

-- [[ Indent Guides ]]
-- https://github.com/lukas-reineke/indent-blankline.nvim
vim.pack.add { gh 'lukas-reineke/indent-blankline.nvim' }

local hooks = require "ibl.hooks"
-- Hide the first space indent level to match popular minimal setups
hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

require('ibl').setup {
  indent = { char = "│", highlight = "IblChar" },
  scope = { char = "│", highlight = "IblScopeChar" },
}
