--[[
Neovim init file
Author: William
Inspiration:
- https://github.com/LunarVim/nvim-basic-ide
- https://github.com/brainfucksec/neovim-lua
- https://github.com/craftzdog/dotfiles-public
- https://github.com/LunarVim/Neovim-from-scratch
--]]

require("user.options")
require("user.keymaps")
require("user.plugins") -- Import Lua Plugins
require("user.autocommands")
require("user.colorscheme")
require("user.cmp")
require("user.telescope")
require("user.treesitter")
require("user.autopairs")
require("user.comment")
require("user.gitsigns")
require("user.nvim-tree")
require("user.bufferline")
require("user.lualine")
require("user.toggleterm")
require("user.project")
require("user.impatient")
require("user.illuminate")
require("user.indentline")
require("user.alpha")
require("user.lsp")
require("user.todo")
