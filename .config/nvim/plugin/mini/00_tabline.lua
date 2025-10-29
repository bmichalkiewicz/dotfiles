-- ┌───────────────┐
-- │ Mini.tabline  │
-- └───────────────┘
--
-- Tabline. Sets `:h 'tabline'` to show all listed buffers in a line at the top.
-- Buffers are ordered as they were created. Navigate with `[b` and `]b`.

MiniDeps.now(function() require('mini.tabline').setup() end)
