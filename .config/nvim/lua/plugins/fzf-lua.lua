-----------------------------------------------------------
-- fzf-lua configuration
-- URL: https://github.com/ibhagwan/fzf-lua
-----------------------------------------------------------

local status_ok, fzf_lua = pcall(require, 'fzf-lua')
if not status_ok then
  return
end

fzf_lua.setup({})
fzf_lua.register_ui_select()
