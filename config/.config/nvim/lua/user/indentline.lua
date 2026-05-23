local status_ok, indent_blankline = pcall(require, "indent_blankline")
if not status_ok then
	return
end

vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")

indent_blankline.setup({
	show_trailing_blankline_indent = false,
	show_first_indent_level = true,
	space_char_blankline = " ",
	use_treesitter = true,
	show_current_context = true,
})
