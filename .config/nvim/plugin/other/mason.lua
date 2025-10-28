-- ┌──────────────────────┐
-- │ Mason Package Manager│
-- └──────────────────────┘
--
-- 'mason-org/mason.nvim' (a.k.a. "Mason") is a great tool (package manager) for
-- installing external language servers, formatters, and linters.

local add = MiniDeps.add
local later = MiniDeps.later

later(function()
  vim.pack.add({ "https://github.com/mason-org/mason.nvim" }, { load = true })
  vim.pack.add({ "https://github.com/mason-org/mason-lspconfig.nvim" }, { load = true })

  require('mason').setup()
  require("mason-lspconfig").setup({
    ensure_installed = {
      "terraformls",                     -- Terraform
      "dockerls",                        -- Dockerfile
      "docker_compose_language_service", -- Docker Compose
      "bashls",                          -- Bash
      "ansiblels",                       -- Ansible
      "yamlls",                          -- YAML
      "jsonls",                          -- JSON
      "gopls",                           -- Go
      "marksman",                        -- Markdown
      "helm_ls",                         -- Helm
    },
    automatic_installation = true,
  })
end)
