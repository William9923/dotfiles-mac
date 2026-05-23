return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  lazy = true,
  cmd = "ConformInfo",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      sh = { "shfmt" },
      python = { "black", "isort" },
      javascript = { "prettier", "prettierd", stop_after_first = true },
      javascriptreact = { "prettier", "prettierd", stop_after_first = true },
      typescript = { "prettier", "prettierd", stop_after_first = true },
      typescriptreact = { "prettier", "prettierd", stop_after_first = true },
      rust = { "rustfmt" },
      go = { "goimports", "gofmt", stop_after_first = true },
      sql = { "pg_format", "sql_formatter" },
      yaml = { "yamlfmt" },
      ruby = { "rubyfmt", "rubocop", stop_after_first = true },
      eruby = { "rubyfmt", "rubocop", stop_after_first = true },
    },
    formatters = {
      rubocop = {
        command = "bin/rubocop", -- use your project's binstub
        args = { "--server", "--auto-correct-all", "--stderr", "--force-exclusion", "--stdin", "$FILENAME" },
        stdin = true,
        cwd = require("conform.util").root_file({ ".rubocop.yml", ".git" }), -- optional: set project root
      },
    },
  },
}
