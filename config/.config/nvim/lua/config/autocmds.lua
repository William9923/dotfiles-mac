-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" }, -- NOTE: add file to disable the conceallevel here
  callback = function()
    vim.opt.conceallevel = 0
  end,
})

-- NOTE: Give highlight for current LSP Reference text
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    vim.cmd("hi link illuminatedWord LspReferenceText")
  end,
})

local function set_relative_line_number_highlights()
  local ok, colors = pcall(function()
    return require("solarized-osaka.colors").setup()
  end)

  if ok then
    vim.api.nvim_set_hl(0, "LineNrAbove", { fg = colors.red500 })
    vim.api.nvim_set_hl(0, "LineNrBelow", { fg = colors.cyan500 })
  else
    vim.cmd("hi! link LineNrAbove LineNr")
    vim.cmd("hi! link LineNrBelow LineNr")
  end
end

-- Distinguish relative line numbers using the active Solarized Osaka palette.
vim.api.nvim_create_autocmd({ "ColorScheme", "BufEnter" }, {
  callback = set_relative_line_number_highlights,
})

-- NOTE: apply auto format on specific file type
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.go", "*.py" },
  callback = function(args)
    if type(args.buf) == "number" then
      require("conform").format({ bufnr = args.buf })
    else
      vim.notify("Conform: Invalid buffer number", vim.log.levels.ERROR)
    end
  end,
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})
