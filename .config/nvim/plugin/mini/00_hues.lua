-- ┌─────────────┐
-- │ Colorscheme │
-- └─────────────┘
--
-- Enable 'miniwinter' color scheme. It comes with 'mini.nvim' and uses 'mini.hues'.
--
-- See also:
-- - `:h mini.nvim-color-schemes` - list of other color schemes
-- - `:h MiniHues-examples` - how to define highlighting with 'mini.hues'

local now = MiniDeps.now

-- You can try these other 'mini.hues'-based color schemes (uncomment with `gcc`):
-- now(function() vim.cmd('colorscheme minispring') end)
now(function() vim.cmd('colorscheme minisummer') end)
-- now(function() vim.cmd('colorscheme miniautumn') end)
-- now(function() vim.cmd('colorscheme miniwinter') end)
