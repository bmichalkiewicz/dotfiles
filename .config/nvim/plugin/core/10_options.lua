--stylua: ignore start

-- Global settings
vim.g.mapleader      = ","
vim.g.maplocalleader = ","

-- General settings
vim.o.breakindentopt = "list:-1"
vim.o.complete       = '.,w,b,kspell'
vim.o.completeopt    = "menuone,noselect,fuzzy"
vim.o.conceallevel   = 2
vim.o.confirm        = true
vim.o.expandtab      = true
vim.o.formatlistpat  = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
vim.o.formatoptions  = "jcrql1nt"
vim.o.grepformat     = "%f:%l:%c:%m"
vim.o.grepprg        = "rg --vimgrep"
vim.o.list           = true
vim.o.pumheight      = 10
vim.o.shiftround     = true
vim.o.shiftwidth     = 2
vim.o.softtabstop    = 2
vim.o.tabstop        = 2
vim.o.shortmess      = "FOSWICaco"
vim.o.spelloptions   = "camel"
vim.o.splitkeep      = "cursor"
vim.o.textwidth      = 78
vim.o.wildmode       = "longest:full,full"
vim.o.winborder      = "rounded"
vim.o.winminwidth    = 5

-- CLipboard
vim.o.clipboard      = "unnamedplus"
if vim.fn.has('wsl') == 1 then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end
-- Fold settings
vim.o.foldexpr    = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel   = 99
vim.o.foldmethod  = "expr"
vim.o.foldnestmax = 10
vim.o.foldtext    = ""

vim.opt.fillchars = { fold = "╌", diff = "╱", eob = " " }
vim.opt.listchars = { extends = "…", precedes = "…", tab = "  ", nbsp = "␣" }

--stylua: ignore end
