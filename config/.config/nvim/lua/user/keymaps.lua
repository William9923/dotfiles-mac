-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Close buffers
keymap("n", "<S-q>", "<cmd>Bdelete!<CR>", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Better keybinding when searching
keymap("n", ".", ";")
keymap("v", ".", ";")

-- Fast saving with Ctrl + s
keymap("n", "<C-s>", ":w<CR>", opts)

-- Select All with Ctrl + a
keymap("n", "<C-a>", "gg<S-v>G", opts)
keymap("v", "<C-a>", "gg<S-v>G", opts)

-- Easier Replace
keymap("n", "r", "R", opts)

-- Increment/decrement digits
keymap("n", "+", "<C-a>", opts)
keymap("n", "-", "<C-x>", opts)

-- Delete without yanking
keymap("n", "d", '"_d', opts)
keymap("n", "x", '"_x', opts)

-- Open current directories + File
keymap("n", "te", ":tabedit<CR>", opts) -- new tab
-- keymap("n", "<S-Tab>", ":tabprev<Return>", opts) -- prev tab
-- keymap("n", "<Tab>", ":tabnext<Return>", opts) -- next tab

-- Splitting windows
keymap("n", "<leader>ss", ":split<Return><C-w>w", opts) -- split windows (horizontal)
keymap("n", "<leader>sv", ":vsplit<Return><C-w>w", opts) -- split windows (vertical)
keymap("n", "<leader>sq", "<C-w>q", opts) -- close split windows

-- Stay in normal/visual mode when entering
keymap("n", "<CR>", "i<CR><esc>", opts)
keymap("v", "<CR>", "i<CR><esc>", opts)

-- Insert --
-- Press kk fast to enter
keymap("i", "kk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<S-j>", ":m .+1<CR>==gv", opts)
keymap("v", "<S-k>", ":m .-2<CR>==gv", opts)
keymap("x", "<S-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<S-k>", ":move '<-2<CR>gv-gv", opts)

-- LSP --
keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
keymap("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
keymap("n", "gr", "<cmd>Trouble lsp_references<CR>", opts)
keymap("n", "<leader>ff", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)

-- LspSaga
keymap("n", "K", "<Cmd>Lspsaga hover_doc<CR>", opts)
keymap("n", "<leader>a", "<cmd>LSoutlineToggle<CR>", opts)
keymap("n", "gp", "<cmd>Lspsaga preview_definition<CR>", opts)
keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", opts)
keymap("n", "<leader>f", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
keymap("n", "<leader>f", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
keymap("n", "<leader>la", "<cmd>Lspsaga code_action<CR>", opts)
keymap("n", "<leader>lr", "<cmd>Lspsaga rename<CR>", opts)
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
keymap("n", "]E", function()
	require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end, opts)
keymap("n", "[E", function()
	require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, opts)

-- Special command (Formatting)
vim.cmd([[ command! Format execute '<cmd>lua vim.lsp.buf.format{ async = true }<cr>' ]])

-- Plugins --
-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
keymap("n", "<leader>rr", "<cmd>NvimTreeRefresh<CR>", opts)

-- Telescope
keymap("n", ";f", ":Telescope find_files<CR>", opts)
keymap("n", ";r", ":Telescope live_grep<CR>", opts)
keymap("n", ";b", ":Telescope buffers<CR>", opts)
keymap("n", ";d", ":Telescope diagnostics<CR>", opts)
keymap("n", ";t", ":TodoTelescope<CR>", opts)
keymap("n", ";h", ":Telescope help_tags<CR>", opts)
keymap("n", ";k", ":Telescope keymaps<CR>", opts)

-- Toggle Term Features
keymap("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)
keymap("n", "<leader>pr", "<cmd>lua _GLOW_TOGGLE()<CR>", opts)
keymap("n", "<leader>nn", "<cmd>lua _SECOND_BRAIN_TOGGLE()<CR>", opts)

-- Comment
keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle_current_linewise()<CR>", opts)
keymap("x", "<leader>/", '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>')

-- Barbar
-- Move to previous/next tab
keymap("n", "<leader>,", "<Cmd>BufferPrevious<CR>", opts)
keymap("n", "<leader>.", "<Cmd>BufferNext<CR>", opts)

-- Re-order to previous/next tab
keymap("n", "<leader><", "<Cmd>BufferMovePrevious<CR>", opts)
keymap("n", "<leader>>", "<Cmd>BufferMoveNext<CR>", opts)
-- Close buffer
keymap("n", "<S-c>", "<Cmd>BufferClose<CR>", opts)

-- Refactoring
keymap("v", "<leader>tr", "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>")
