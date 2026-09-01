local ns = vim.api.nvim_create_namespace('cmdline_ui')
_G.custom_cmdline = nil

vim.ui_attach(ns, {ext_cmdline = true}, function(event, ...)
  if event == 'cmdline_show' then
    local content, pos, firstc, prompt, indent, level = ...
    local text = ""
    for _, chunk in ipairs(content) do
      text = text .. chunk[2]
    end
    _G.custom_cmdline = { text = text, firstc = firstc, pos = pos, prompt = prompt }
    vim.cmd('redrawstatus')
  elseif event == 'cmdline_hide' then
    _G.custom_cmdline = nil
    vim.cmd('redrawstatus')
  elseif event == 'cmdline_pos' then
    local pos, level = ...
    if _G.custom_cmdline then
      _G.custom_cmdline.pos = pos
      vim.cmd('redrawstatus')
    end
  end
end)
