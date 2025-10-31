MiniDeps.later(function()
  vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" }, { load = true })
  local lint = require("lint")
  lint.linters_by_ft = {
    go = { "golangcilint" },
    sh = { "shellcheck" },
  }

  Config.new_autocmd(
    { "BufEnter", "BufWritePost", "InsertLeave" },
    nil,
    function()
      lint.try_lint()
    end,
    "Run linter on buffer events"
  )
end)
