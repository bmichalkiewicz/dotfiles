-- ┌────────────┐
-- │ Mini.move  │
-- └────────────┘
--
-- Move any selection in any direction. Example usage in Normal mode:
-- - `<M-j>`/`<M-k>` - move current line down / up
-- - `<M-h>`/`<M-l>` - decrease / increase indent of current line
--
-- Example usage in Visual mode:
-- - `<M-h>`/`<M-j>`/`<M-k>`/`<M-l>` - move selection left/down/up/right

MiniDeps.later(function() require('mini.move').setup({
  mappings = {
    left       = '<S-left>',
    right      = '<S-right>',
    down       = '<S-down>',
    up         = '<S-up>',

    line_left  = '<S-left>',
    line_right = '<S-right>',
    line_down  = '<S-down>',
    line_up    = '<S-up>',
  }
})
end)
