local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = false,
	always_visible = true,
}

local diff = {
	"diff",
	colored = false,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
	cond = hide_in_width,
}

local filetype = {
	"filetype",
	icons_enabled = false,
}

local location = {
	"location",
	padding = 0,
}

local spaces = function()
	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

-- local cp_status_ok, cp = pcall(require, "catppuccin.core.palettes.init")
-- if not cp_status_ok then
-- 	return
-- end
--
-- local custom_catppuccin_status_ok, custom_catppuccin = pcall(require, "lualine.themes.catppuccin")
-- if not custom_catppuccin_status_ok then
-- 	return
-- end
--
-- custom_catppuccin.normal.b.bg = cp.surface0
-- custom_catppuccin.normal.c.bg = cp.base
-- custom_catppuccin.insert.b.bg = cp.surface0
-- custom_catppuccin.command.b.bg = cp.surface0
-- custom_catppuccin.visual.b.bg = cp.surface0
-- custom_catppuccin.replace.b.bg = cp.surface0
-- custom_catppuccin.inactive.a.bg = cp.base
-- custom_catppuccin.inactive.b.bg = cp.base
-- custom_catppuccin.inactive.b.fg = cp.surface0
-- custom_catppuccin.inactive.c.bg = cp.base
--
-- local pallete = cp.get_palette()
lualine.setup({
	options = {
		globalstatus = true,
		icons_enabled = true,
		theme = "nord",
		section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
		disabled_filetypes = { "alpha", "dashboard" },
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = { diagnostics },
		lualine_x = { diff, spaces, "encoding", filetype },
		lualine_y = { location },
		lualine_z = { "progress" },
	},
})
