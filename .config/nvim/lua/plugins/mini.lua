-----------------------------------------------------------
-- Mini.nvim configuration
-- URL: https://github.com/echasnovski/mini.nvim
-----------------------------------------------------------

-- Helper function to safely load plugins
local function load(module, config)
  local ok, plugin = pcall(require, module)
  if not ok then
    return
  end
  plugin.setup(config or {})
  return plugin
end

-----------------------------------------------------------
-- Mini Comment
-- See :help MiniComment.config
-----------------------------------------------------------
load("mini.comment")

-----------------------------------------------------------
-- Mini Surround
-- See :help MiniSurround.config
-----------------------------------------------------------
load("mini.surround")

-----------------------------------------------------------
-- Mini Notify
-- See :help MiniNotify.config
-----------------------------------------------------------
local mini_notify = load("mini.notify", {
  lsp_progress = { enable = false },
})
if mini_notify then
  -- Use mini.notify for vim.notify
  vim.notify = mini_notify.make_notify({})
end

-----------------------------------------------------------
-- Mini Bufremove
-- See :help MiniBufremove.config
-----------------------------------------------------------
load("mini.bufremove")

-----------------------------------------------------------
-- Mini Extra
-- See :help MiniExtra
-----------------------------------------------------------
load("mini.extra")

-----------------------------------------------------------
-- Mini Snippets
-- See :help MiniSnippets.config
-----------------------------------------------------------
load("mini.snippets")

-----------------------------------------------------------
-- Mini Completion
-- See :help MiniCompletion.config
-----------------------------------------------------------
load("mini.completion")

-----------------------------------------------------------
-- Mini Pair
-- See :help MiniPairs.config
-----------------------------------------------------------
load("mini.pairs")

-----------------------------------------------------------
-- Mini AI
-- See :help MiniAi-textobject-builtin
-----------------------------------------------------------
load("mini.ai", {
  n_lines = 500
})

-----------------------------------------------------------
-- Mini Jump2D
-- See :help MiniJump2d.config
-----------------------------------------------------------
load("mini.jump2d", {
  mappings = {
    start_jumping = 'S',
  }
})

-----------------------------------------------------------
-- Mini Icons
-----------------------------------------------------------
load("mini.icons")

-----------------------------------------------------------
-- Mini Starter
-----------------------------------------------------------
load("mini.starter")

-----------------------------------------------------------
-- Mini Icons
-----------------------------------------------------------
load("mini.tabline")

-----------------------------------------------------------
-- Mini Files
-- See :help MiniFiles.config
-----------------------------------------------------------
local mini_files = load("mini.files")
if mini_files then
  -- Toggle file explorer
  -- See :help MiniFiles-navigation
  vim.keymap.set("n", "<leader>e", function()
    if mini_files.close() then
      return
    end
    mini_files.open()
  end, { desc = "File explorer" })
end
