local filetype = require("mason-lspconfig.mappings.filetype")
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

-- NOTE: autocmd for line number color (above current line: red, below current line: blue)
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    vim.cmd("hi LineNrAbove guifg=red ctermfg=red")
    vim.cmd("hi LineNrBelow guifg=cyan ctermfg=cyan")
  end,
})

-- NOTE: apply auto format on specific file type
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go", -- autoformat on golang file
  callback = function(args)
    if type(args.buf) == "number" then
      require("conform").format({ bufnr = args.buf })
    else
      vim.notify("Conform: Invalid buffer number", vim.log.levels.ERROR)
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py", -- autoformat on python file
  callback = function(args)
    if type(args.buf) == "number" then
      require("conform").format({ bufnr = args.buf })
    else
      vim.notify("Conform: Invalid buffer number", vim.log.levels.ERROR)
    end
  end,
})
