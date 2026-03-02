-- ┌──────────┐
-- │ Snippets │
-- └──────────┘
--
-- The 'rafamadriz/friendly-snippets' is currently the largest collection of
-- snippet files. 'mini.snippets' is designed to work with it seamlessly.

Config.later(function()
  vim.pack.add({ "https://github.com/rafamadriz/friendly-snippets" }, { load = true })
end)
