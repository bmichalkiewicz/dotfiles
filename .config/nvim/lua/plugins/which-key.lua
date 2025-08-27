-----------------------------------------------------------
-- which-key configuration
-- URL: https://github.com/folke/which-key.nvim
-----------------------------------------------------------

local status_ok, which_key = pcall(require, 'which-key')
if not status_ok then
  return
end

-- See: https://github.com/folke/which-key.nvim?tab=readme-ov-file#%EF%B8%8F-configuration
which_key.setup({
  icons = {
    keys = {
      Space = 'Space',
      Esc = 'Esc',
      BS = 'Backspace',
      C = 'Ctrl-',
    },
  },
})

which_key.add({
  {'<leader>f', group = 'Fuzzy Find'},
  {'<leader>b', group = 'Buffer'},
  {'<leader>c', group = 'Code'},
})
