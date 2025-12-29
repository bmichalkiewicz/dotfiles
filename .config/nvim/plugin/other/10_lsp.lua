-- ┌──────────────────┐
-- │ Language servers │
-- └──────────────────┘
--
-- Language Server Protocol (LSP) is a set of conventions that power creation of
-- language specific tools. Neovim's team collects commonly used configurations
-- for most language servers inside 'neovim/nvim-lspconfig' plugin.

local now_if_args = _G.Config.now_if_args

-- Add it now if file (and not 'mini.starter') is shown after startup.
now_if_args(function()
  vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" }, { load = true })

  -- Enable LSP servers installed via Mason
  vim.lsp.enable({
    'lua_ls',                          -- Lua (configured in after/lsp/lua_ls.lua)
    'terraformls',                     -- Terraform
    'dockerls',                        -- Dockerfile
    'docker_compose_language_service', -- Docker Compose
    'bashls',                          -- Bash
    'ansiblels',                       -- Ansible
    'yamlls',                          -- YAML
    'jsonls',                          -- JSON
    'gopls',                           -- Go
    'basedpyright',                    -- Python
    'marksman',                        -- Markdown
    'helm_ls',                         -- Helm
    'gitlab_ci_ls'                     -- Gitlab CI/CD
  })

  vim.filetype.add({
    pattern = {
      ['%.gitlab%-ci%.ya?ml'] = 'yaml.gitlab',
    },
  })

end)
