local now_if_args = Config.now_if_args

now_if_args(function()
  vim.pack.add({ "https://github.com/towolf/vim-helm" }, { load = true })
end)
