-- Define LSP servers to install and enable (shared with 10_lsp.lua)
Config.lsp_servers = {
  "gopls",
  "lua_ls",
  "basedpyright",
  "marksman",
  "helm_ls",
  "jsonls",
  "yamlls",
  "bashls",
  "ansiblels",
  "dockerls",
}

MiniDeps.later(function()
  vim.pack.add({ "https://github.com/williamboman/mason.nvim" }, { load = true })
  vim.pack.add({ "https://github.com/williamboman/mason-lspconfig.nvim" }, { load = true })

  require("mason").setup()

  require("mason-lspconfig").setup({
    ensure_installed = Config.lsp_servers,
    automatic_installation = true,
  })
end)
