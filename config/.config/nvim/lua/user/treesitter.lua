-----------------------------------------------------------
-- Treesitter configuration file
----------------------------------------------------------

-- Plugin: nvim-treesitter
-- url: https://github.com/nvim-treesitter/nvim-treesitter

local status_ok, treesitter = pcall(require, "nvim-treesitter")
if not status_ok then
	return
end

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

-- See: https://github.com/nvim-treesitter/nvim-treesitter#quickstart
configs.setup({
	autopairs = {
		enable = true,
	},
	autotag = {
		enable = true,
	},
	disable = { "markdown" },
	-- A list of parser names, or "all"
	ensure_installed = {
		-- Lang
		"html",
		"css",
		"c",
		"cpp",
		"javascript",
		"typescript",
		"python",
		"go",
		"rust",
		-- Filetype specific
		"json",
		"toml",
		"markdown",
		-- Bash & script
		"bash",
		"lua",
		"vim",
		"dockerfile",
		-- Framework specific
		"tsx",
	},
	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = true,
	highlight = {
		-- `false` will disable the whole extension
		enable = true,
		additional_vim_regex_highlighting = true,
	},
	indent = { enable = true, disable = { "toml", "yaml", "python", "css" } },
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
})

local status_ok, nvim_ts_autotag = pcall(require, "nvim-ts-autotag")
if not status_ok then
	return
end

local status_ok, treesitter = pcall(require, "nvim-treesitter")
if not status_ok then
	return
end

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end
