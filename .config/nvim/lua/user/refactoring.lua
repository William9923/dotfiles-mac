local refactoring_status_ok, refactoring = pcall(require, "refactoring")
if not refactoring_status_ok then
	return
end

require("refactoring").setup({
	-- prompt for return type
	prompt_func_return_type = {
		go = true,
		cpp = true,
		c = true,
		java = true,
	},
	-- prompt for function parameters
	prompt_func_param_type = {
		go = true,
		cpp = true,
		c = true,
		java = true,
	},
})
