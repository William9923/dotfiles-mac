-----------------------------------------------------------
-- Leap (motion) configuration file
-----------------------------------------------------------

-- Plugin: Leap
-- url: https://github.com/ggandor/leap.nvim

local status_ok, leap = pcall(require, "leap")
if not status_ok then
	return
end

leap.set_default_keymaps()
