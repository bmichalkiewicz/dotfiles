-- ┌─────────────┐
-- │ Colorscheme │
-- └─────────────┘
--
-- Enable 'miniwinter' color scheme. It comes with 'mini.nvim' and uses 'mini.hues'.
--
-- See also:
-- - `:h mini.nvim-color-schemes` - list of other color schemes
-- - `:h MiniHues-examples` - how to define highlighting with 'mini.hues'

-- You can try these other 'mini.hues'-based color schemes (uncomment with `gcc`):
-- MiniDeps.now(function() vim.cmd('colorscheme minispring') end)
MiniDeps.now(function() vim.cmd('colorscheme minisummer') end)
-- MiniDeps.now(function() vim.cmd('colorscheme miniautumn') end)
-- MiniDeps.now(function() vim.cmd('colorscheme miniwinter') end)
