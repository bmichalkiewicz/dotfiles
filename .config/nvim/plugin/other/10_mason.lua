MiniDeps.later(function()
  vim.pack.add({ "https://github.com/williamboman/mason.nvim" }, { load = true })
  vim.pack.add({ "https://github.com/williamboman/mason-lspconfig.nvim" }, { load = true })

  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = {
      -- DevOps Stack
      "terraformls",                     -- Terraform
      "dockerls",                        -- Dockerfile
      "docker_compose_language_service", -- Docker Compose
      "bashls",                          -- Bash
      "ansiblels",                       -- Ansible
      "yamlls",                          -- YAML
      "jsonls",                          -- JSON
      -- Additional languages
      "lua_ls",                          -- Lua
      "gopls",                           -- Go
      "basedpyright",                    -- Python
      "ruff",                            -- Python linter
      "marksman",                        -- Markdown
      "harper_ls",                       -- Grammar/spell check
      "helm_ls",                         -- Helm
    },
    automatic_installation = true,
  })
end)
