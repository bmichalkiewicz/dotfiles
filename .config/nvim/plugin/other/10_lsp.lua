MiniDeps.later(function()
  vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" }, { load = true })

  vim.diagnostic.config({
    underline = false,
    update_in_insert = false,
    -- virtual_text = {
    --   spacing = 4,
    --   source = "if_many",
    --   prefix = "",
    -- },
    severity_sort = true,
  })

  vim.lsp.enable(Config.lsp_servers)

  vim.lsp.config["*"] = {
    capabilities = {
      workspace = {
        fileOperations = {
          didRename = true,
          willRename = true,
        },
      },
    },
  }

  Config.toggle_hints = function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end
end)
