MiniDeps.later(function()
  vim.pack.add({ "https://github.com/williamboman/mason.nvim" }, { load = true })
  vim.pack.add({ "https://github.com/williamboman/mason-lspconfig.nvim" }, { load = true })

  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = {
      "gopls",
      "lua_ls",
      "basedpyright",
      "marksman",
      "helm_ls",
      "jsonls",
      "yamlls",
      "terraformls",
    },
    automatic_installation = true,
  })
end)
