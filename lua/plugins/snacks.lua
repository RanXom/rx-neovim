-- ============================================================================
-- SNACKS.NVIM
-- A collection of QoL plugins for Neovim (Dashboard, etc.)
-- ============================================================================

local gh = require('core.utils').gh

vim.pack.add { gh 'folke/snacks.nvim' }

require("snacks").setup({
  notifier = {
    enabled = true,
    timeout = 3000,
    top_down = false,
    margin = { top = 0, right = 0, bottom = 0 },
    style = function(buf, notif, ctx)
      -- Remove borders to keep it perfectly blocky
      ctx.opts.border = "none"
      -- Disable markdown filetype so indented lines aren't parsed as code blocks
      vim.bo[buf].filetype = ""

      -- Combine icon and message tightly
      local icon = notif.icon or ""
      local msg = notif.msg or ""
      local lines = vim.split(msg, "\n")
      for i, line in ipairs(lines) do
        if i == 1 then
          lines[i] = " " .. icon .. " " .. line .. " "
        else
          lines[i] = "   " .. line .. " "
        end
      end

      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

      -- Highlight the icon specifically, the rest inherits Normal (ctx.hl.msg)
      -- We also forcefully apply ctx.hl.msg via extmarks to every line to guarantee 
      -- NO rogue syntax or markdown highlights can ever make the text white.
      for i = 0, #lines - 1 do
        vim.api.nvim_buf_set_extmark(buf, ctx.ns, i, 0, {
          end_col = #lines[i + 1],
          hl_group = ctx.hl.msg,
          priority = 100,
        })
      end

      -- Overlay the icon highlight
      if icon ~= "" then
        vim.api.nvim_buf_set_extmark(buf, ctx.ns, 0, 1, {
          end_col = 1 + #icon,
          hl_group = ctx.hl.icon,
          priority = 101,
        })
      end
    end,
  },
  dashboard = {
    enabled = true,
    -- Customize your dashboard here. 
    -- Example presets or configurations can be changed below.
    preset = {
      -- You can change the header text, art, or keys here:
      header = [[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ランサム
██████╗  █████╗ ███╗   ██╗██╗  ██╗ ██████╗ ███╗   ███╗
██╔══██╗██╔══██╗████╗  ██║╚██╗██╔╝██╔═══██╗████╗ ████║
██████╔╝███████║██╔██╗ ██║ ╚███╔╝ ██║   ██║██╔████╔██║
██╔══██╗██╔══██║██║╚██╗██║ ██╔██╗ ██║   ██║██║╚██╔╝██║
██║  ██║██║  ██║██║ ╚████║██╔╝ ██╗╚██████╔╝██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ]],
      -- Example custom keys
      -- keys = {
      --   { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
      --   { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
      --   { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
      --   { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
      --   { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      -- },
    },
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
    },
  },
})

-- snacks.dashboard forces the statusline to hide (laststatus = 0).
-- We force it back to 3 whenever the dashboard opens.
vim.api.nvim_create_autocmd("User", {
  pattern = "SnacksDashboardOpened",
  callback = function()
    vim.o.laststatus = 3
  end,
})
