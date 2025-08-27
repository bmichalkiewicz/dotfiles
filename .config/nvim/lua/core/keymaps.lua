-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------

local function map(mode, lhs, rhs, opts)
  local options = { noremap=true, silent=true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Change leader to a comma
vim.g.mapleader = ','

-----------------------------------------------------------
-- Neovim shortcuts
-----------------------------------------------------------

-- Disable arrow keys
map('', '<up>', '<nop>', {desc = 'Disable up arrow key'})
map('', '<down>', '<nop>', {desc = 'Disable down arrow key'})
map('', '<left>', '<nop>', {desc = 'Disable left arrow key'})
map('', '<right>', '<nop>', {desc = 'Disable right arrow key'})

-- Map Esc to kk
map('i', 'kk', '<Esc>', {desc = 'Exit insert mode'})

-- Move around splits using Ctrl + {h,j,k,l}
map('n', '<C-h>', '<C-w>h', {desc = 'Move to left split'})
map('n', '<C-j>', '<C-w>j', {desc = 'Move to split below'})
map('n', '<C-k>', '<C-w>k', {desc = 'Move to split above'})
map('n', '<C-l>', '<C-w>l', {desc = 'Move to right split'})

-- Reload configuration without restart nvim
map('n', '<leader>r', ':so %<CR>', {desc = 'Reload current file configuration'})

-- Fast saving with <leader> and s
map('n', '<leader>s', ':w<CR>', {desc = 'Save current file'})

-- Close all windows and exit from Neovim with <leader> and q
map('n', '<leader>q', ':qa!<CR>', {desc = 'Force quit all windows'})

-----------------------------------------------------------
-- Applications and Plugins shortcuts
-----------------------------------------------------------
-- Terminal mappings
map('n', '<C-t>', ':Term<CR>', {noremap = true, desc = 'Open terminal'})
map('t', '<Esc>', '<C-\\><C-n>', {desc = 'Exit terminal mode'})

-- Close buffer and preserve window layout
vim.keymap.set('n', '<leader>bc', '<cmd>lua pcall(MiniBufremove.delete)<cr>', {desc = 'Close buffer'})
