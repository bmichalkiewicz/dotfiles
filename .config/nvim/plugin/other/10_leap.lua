MiniDeps.later(function()
  vim.pack.add({ "https://codeberg.org/andyg/leap.nvim" }, { load = true })
  require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }
end)

