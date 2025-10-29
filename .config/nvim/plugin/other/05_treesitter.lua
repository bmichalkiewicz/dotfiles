-- ┌─────────────────┐
-- │ Tree-sitter     │
-- └─────────────────┘
--
-- Tree-sitter is a tool for fast incremental parsing. It converts text into
-- a hierarchical structure (called tree) that can be used to implement advanced
-- and/or more precise actions: syntax highlighting, textobjects, indent, etc.

local now_if_args = _G.Config.now_if_args

-- Add these plugins now if file (and not 'mini.starter') is shown after startup.
now_if_args(function()
  -- Add post hook to run after every update, but not first-time install
  Config.new_autocmd('User', 'PackChanged', function(ev)
    local name, active, kind = ev.data.spec.name, ev.data.active, ev.data.kind
    if name == "tree-sitter" and kind == "update" and active then
      vim.cmd("TSUpdate")
    end
  end, 'Auto-update tree-sitter parsers')

  vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
  }, { load = true })

  -- Define languages which will have parsers installed and auto enabled
  local languages = {
    -- These are already pre-installed with Neovim. Used as an example.
    'lua',
    'vimdoc',
    'markdown',
    'terraform',       -- Terraform/HCL
    'hcl',             -- HashiCorp Configuration Language
    'dockerfile',      -- Docker
    'yaml',            -- YAML configs
    'json',            -- JSON configs
    'bash',            -- Shell scripts
    'go',              -- Go
    'python',          -- Python scripts
    'toml',            -- TOML configs
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
