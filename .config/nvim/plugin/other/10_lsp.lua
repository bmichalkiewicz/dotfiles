MiniDeps.later(function()
  vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" }, { load = true })

  -- All language servers are expected to be installed with 'mason.nvim'
  vim.lsp.enable({
    -- DevOps Stack
    "terraformls",
    "dockerls",
    "docker_compose_language_service",
    "bashls",
    "ansiblels",
    "yamlls",
    "jsonls",
    -- Programming Languages
    "gopls",
    "ruff",
    "lua_ls",
    "basedpyright",
    -- Documentation
    "marksman",
    "harper_ls",
    "helm_ls",
  })

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
