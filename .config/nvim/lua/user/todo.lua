-----------------------------------------------------------
-- Todo Comments Configuration
-----------------------------------------------------------

-- Plugin: Todo comments
-- url: https://github.com/folke/todo-comments.nvim

local status_ok, todo = pcall(require, "todo-comments")
if not status_ok then
	return
end

todo.setup({
	keywords = {
		FIX = {
			icon = " ", -- icon used for the sign, and in search results
			color = "error", -- can be a hex color, or a named color (see below)
			alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
		},
		TODO = { icon = " ", color = "info" },
		WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
		NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
	},
})
