return {
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      -- MDX
      vim.filetype.add({
        extension = {
          mdx = "mdx",
        },
      })
      vim.treesitter.language.register("markdown", "mdx")
    end,
    opts = {
      ensure_installed = {
        -- go related syntax
        "go",
        "gomod",
        "gowork",
        "gosum",
        -- python related syntax
        "python",
        "rst",
        "toml",
        -- terrafor related syntax
        "terraform",
        "hcl",
        -- for noice.nvim
        "regex",
        "markdown_inline",
        -- ruby related
        "ruby",

        -- unrelated, but good to have
        "gitignore",
        "typescript",
        "rust",
        "sql",
        "html",
        "css",
        "javascript",
        "json",
        "tsx",
        "toml",
        "markdown",
        "bash",

        -- scripting based
        "lua",
        "vim",
        "dockerfile",
      },
      indent = { enable = true, disable = { "toml", "yaml", "python", "css" } },
    },
  },
}
