-- Gruvbox
-- local colorscheme = "gruvbox"
-- vim.o.background = "dark"

-- Nord
local colorscheme = "nord"
vim.o.background = "dark"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	return
end

-- Catpuccin
-- local colorscheme = "catppuccin"
-- vim.g.catppuccin_flavour = "mocha"
--
-- local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
-- if not status_ok then
-- 	return
-- end
--
-- -- Integration with other plugins
-- local catppuccin_status_ok, catppuccin = pcall(require, "catppuccin")
-- if not catppuccin_status_ok then
-- 	return
-- end
--
-- catppuccin.setup({
-- 	transparent_background = true,
-- })
