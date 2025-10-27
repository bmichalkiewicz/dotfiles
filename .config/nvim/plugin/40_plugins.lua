-- ┌────────────────────────────────┐
-- │ Plugins Outside Of Mini.nvim   │
-- └────────────────────────────────┘
--
-- This file contains plugins that are not part of the mini.nvim ecosystem.
-- Each plugin is loaded with MiniDeps and configured as needed.

local add = MiniDeps.add
local later = MiniDeps.later
local now_if_args = _G.Config.now_if_args

-- ┌─────────────────┐
-- │ Tree-sitter     │
-- └─────────────────┘
--
-- Tree-sitter is a tool for fast incremental parsing. It converts text into
-- a hierarchical structure (called tree) that can be used to implement advanced
-- and/or more precise actions: syntax highlighting, textobjects, indent, etc.

-- Add these plugins now if file (and not 'mini.starter') is shown after startup.
now_if_args(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    -- Use `main` branch since `master` branch is frozen, yet still default
    checkout = 'main',
    -- Update tree-sitter parser after plugin is updated
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  add({
    source = 'nvim-treesitter/nvim-treesitter-textobjects',
    -- Same logic as for 'nvim-treesitter'
    checkout = 'main',
  })

  -- Define languages which will have parsers installed and auto enabled
  local languages = {
    -- These are already pre-installed with Neovim. Used as an example.
    'lua',
    'vimdoc',
    'markdown',
    -- DevOps & Infrastructure
    'terraform',       -- Terraform/HCL
    'hcl',             -- HashiCorp Configuration Language
    'dockerfile',      -- Docker
    'yaml',            -- YAML configs
    'json',            -- JSON configs
    'bash',            -- Shell scripts
    'go',              -- Go
    'python',          -- Python scripts
    'toml',            -- TOML configs
    -- Web Development
    'html',
    'css',
    'javascript',
    'typescript',
    'tsx',
  }
  local isnt_installed = function(lang)
    return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
  end
  local to_install = vim.tbl_filter(isnt_installed, languages)
  if #to_install > 0 then require('nvim-treesitter').install(to_install) end

  -- Enable tree-sitter after opening a file for a target language
  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  local ts_start = function(ev) vim.treesitter.start(ev.buf) end
  _G.Config.new_autocmd('FileType', filetypes, ts_start, 'Start tree-sitter')
end)

-- ┌──────────────────┐
-- │ Language servers │
-- └──────────────────┘
--
-- Language Server Protocol (LSP) is a set of conventions that power creation of
-- language specific tools. Neovim's team collects commonly used configurations
-- for most language servers inside 'neovim/nvim-lspconfig' plugin.

-- Add it now if file (and not 'mini.starter') is shown after startup.
now_if_args(function()
  add('neovim/nvim-lspconfig')

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
    'marksman',                        -- Markdown
    'helm_ls',                         -- Helm
  })
end)

-- ┌────────────┐
-- │ Formatting │
-- └────────────┘
--
-- The 'stevearc/conform.nvim' plugin is a good and maintained solution for easier
-- formatting setup.

later(function()
  add('stevearc/conform.nvim')

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

-- ┌──────────────────────┐
-- │ Mason Package Manager│
-- └──────────────────────┘
--
-- 'mason-org/mason.nvim' (a.k.a. "Mason") is a great tool (package manager) for
-- installing external language servers, formatters, and linters.

later(function()
  add('mason-org/mason.nvim')
  add('mason-org/mason-lspconfig.nvim')

  require('mason').setup()
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
      "gopls",                           -- Go
      "marksman",                        -- Markdown
      "helm_ls",                         -- Helm
    },
    automatic_installation = true,
  })
end)

-- ┌──────────┐
-- │ Snippets │
-- └──────────┘
--
-- The 'rafamadriz/friendly-snippets' is currently the largest collection of
-- snippet files. 'mini.snippets' is designed to work with it seamlessly.

later(function()
  add('rafamadriz/friendly-snippets')
end)
