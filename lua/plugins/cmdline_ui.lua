local ns = vim.api.nvim_create_namespace('cmdline_ui')
_G.custom_cmdline = nil

vim.ui_attach(ns, {ext_cmdline = true, ext_messages = true}, function(event, ...)
  if event == 'cmdline_show' then
    local content, pos, firstc, prompt, indent, level = ...
    local text = ""
    for _, chunk in ipairs(content) do
      text = text .. chunk[2]
    end
    _G.custom_cmdline = { text = text, firstc = firstc, pos = pos, prompt = prompt }
    _G.ignore_next_return_prompt = false
    vim.schedule(function() vim.cmd('redrawstatus') end)
  elseif event == 'cmdline_hide' then
    _G.custom_cmdline = nil
    _G.ignore_next_return_prompt = false
    vim.schedule(function() vim.cmd('redrawstatus') end)
  elseif event == 'cmdline_pos' then
    local pos, level = ...
    if _G.custom_cmdline then
      _G.custom_cmdline.pos = pos
      vim.schedule(function() vim.cmd('redrawstatus') end)
    end
  elseif event == 'msg_show' then
    local kind, content, replace_last = ...
    local text = ""
    for _, chunk in ipairs(content) do
      text = text .. chunk[2]
    end
    
    if text:match("E21: Cannot make changes") then
      _G.ignore_next_return_prompt = true
      return
    end

    if kind == 'return_prompt' and _G.ignore_next_return_prompt then
      _G.ignore_next_return_prompt = false
      vim.schedule(function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
      end)
      return
    end

    if kind == 'confirm' or kind == 'confirm_sub' or kind == 'return_prompt' then
      if kind == 'confirm' then
        -- First message: the question itself ("Save changes to foo?")
        -- Store it separately; choices will arrive as confirm_sub next
        _G.custom_cmdline = { question = text, text = '', firstc = '', pos = 0, prompt = '' }
      elseif kind == 'confirm_sub' and _G.custom_cmdline and _G.custom_cmdline.question then
        -- Second message: the choices ("[Y]es, (N)o, (C)ancel:")
        _G.custom_cmdline.text = text
      elseif _G.custom_cmdline and _G.custom_cmdline.question then
        -- return_prompt or other sub-message: append to choices
        _G.custom_cmdline.text = (_G.custom_cmdline.text or '') .. text
      else
        -- Fallback for unexpected prompts without a preceding confirm
        _G.custom_cmdline = { text = text, firstc = '', pos = 0, prompt = '' }
      end
      vim.schedule(function() vim.cmd('redrawstatus') end)
    else
      -- Route normal messages to snacks.notifier if available and not empty
      if text ~= "" then
        vim.schedule(function()
          local ok, snacks = pcall(require, 'snacks')
          if ok and snacks.notifier then
            snacks.notifier.notify(text, "info", { title = "Neovim" })
          end
        end)
      end
    end
  elseif event == 'msg_clear' then
    if _G.custom_cmdline and _G.custom_cmdline.firstc == '' then
      _G.custom_cmdline = nil
      vim.schedule(function() vim.cmd('redrawstatus') end)
    end
  end
end)
