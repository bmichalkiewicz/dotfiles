-- ┌────────────┐
-- │ Formatting │
-- └────────────┘
--
-- The 'stevearc/conform.nvim' plugin is a good and maintained solution for easier
-- formatting setup.

local add = MiniDeps.add
local later = MiniDeps.later

later(function()
  vim.pack.add({ "https://github.com/stevearc/conform.nvim" }, { load = true })
  -- See also:
  -- - `:h Conform`
  -- - `:h conform-options`
  -- - `:h conform-formatters`
  require('conform').setup({
    notify_on_error = true,
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    -- Map of filetype to formatters
    formatters_by_ft = {
      css = { 'prettierd' },
      html = { 'prettierd' },
      javascript = { 'prettierd' },
      json = { 'prettierd' },
      yaml = { 'prettierd' },
      markdown = { 'prettierd' },
    },
  })
end)
