-- ┌────────────────┐
-- │ Mini.sessions  │
-- └────────────────┘
--
-- Session management. A thin wrapper around `:h mksession` that consistently
-- manages session files. Example usage:
-- - `<Leader>sn` - start new session
-- - `<Leader>sr` - read previously started session
-- - `<Leader>sd` - delete previously started session

local now = MiniDeps.now

now(function() require('mini.sessions').setup() end)
