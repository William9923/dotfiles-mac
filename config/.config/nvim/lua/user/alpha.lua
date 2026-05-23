local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

local date_gen = io.popen('echo "$(date +%d)/$(date +%m)/$(date +%y)($(date +%a))$(date +%X)" | tr -d "\n"')
local date = date_gen:read("*a")
date_gen:close()

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
	[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	[[⣿⡿⢿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠃⢰⡆⠘⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢿⣿]],
	[[⠁⢠⣄⣈⠉⠛⠿⠿⠟⠉⠀⠀⠀⠀⣸⣇⠀⠀⠀⠀⠉⠻⠿⠿⠛⠉⣁⣠⡄⠈]],
	[[⣦⣀⠉⠻⢿⣶⣤⣄⡀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⢀⣠⣤⣶⡿⠟⠉⣀⣴]],
	[[⣿⣿⣷⣦⡄⠈⠙⠿⣿⣿⣶⣤⣄⣠⣿⣿⣄⣠⣤⣶⣿⣿⠿⠋⠁⢠⣴⣾⣿⣿]],
	[[⣿⡿⠿⠛⠀⠀⢰⣤⣀⠉⠻⢿⣿⣿⣿⣿⣿⣿⡿⠟⠉⣀⣤⡆⠀⠀⠛⠿⢿⣿]],
	[[⠁⠀⠀⠀⠀⠀⢸⣿⣯⣠⣦⡄⠈⠙⠛⠛⠋⠁⢠⣴⣄⣿⣿⡇⠀⠀⠀⠀⠀⠈]],
	[[⡀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠀⠀⠀⠀⠀⠀⢀]],
	[[⣿⣷⣦⣤⣀⠀⠀⠀⠀⠀⠀⢠⡀⠀⣀⣀⠀⢀⡄⠀⠀⠀⠀⠀⠀⣀⣤⣴⣾⣿]],
	[[⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⢸⣇⢠⣿⣿⡄⣸⡇⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿]],
	[[⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⢈⡉⠉⠙⠋⠉⣉⡁⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣷⣶⣤⣀⠀⢸⣿⣿⣿⣿⣿⣿⡇⠀⣀⣤⣶⣾⣿⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⢸⡏⠘⣿⣿⠃⢹⡇⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠈⠁⠀⠉⠉⠀⠈⠁⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	"",
	"   " .. date,
}

dashboard.section.buttons.val = {
	dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
	dashboard.button("g", " " .. " Git", "<cmd>lua _LAZYGIT_TOGGLE()<CR>"),
	dashboard.button("c", " " .. " Config", ":e ~/.config/nvim/init.lua <CR>"),
	dashboard.button("q", " " .. " Quit", ":qa<CR>"),
}
local function footer()
	return {
		[[~~ created with love ❦ ~~]],
		[[    by: William Ong      ]],
	}
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
