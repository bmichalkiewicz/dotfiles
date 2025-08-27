-----------------------------------------------------------
-- Color schemes configuration file
-----------------------------------------------------------

--[[
Set Neovim UI color scheme.
Current available color schemes: onedark, kanagawa, monokai-pro, rose-pine.
See: https://github.com/brainfucksec/neovim-lua#appearance

Insert preferred color scheme in the `color_scheme` variable.
Note: Color scheme is loaded in the "Load color scheme" section below, setup
must be called before loading.
--]]
local status_ok, color_scheme = pcall(require, 'catppuccin')
if not status_ok then
  return
end

--[[
Color schemes settings:
For configuration of the color scheme refer to the project instructions,
usually found in the README file of the git package.
--]]

-- Catppuccin
-- https://github.com/catppuccin/nvim
require("catppuccin").setup({
    flavour = "frappe", -- latte, frappe, macchiato, mocha
    transparent_background = false, -- disables setting the background color.
    auto_integrations = true,
})

--[[
Load color scheme:
Note: The instruction to load the color scheme may vary depending on the
package.
See the README of the related color scheme (i.e. git package) for information,
Examples: require('color_scheme').setup{}, vim.cmd('color_scheme')
--]]
--]]
vim.cmd.colorscheme "catppuccin"
