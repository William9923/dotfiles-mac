return {
  {
    "nvim-treesitter/nvim-treesitter",
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

      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },

      playground = {
        enable = true,
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        disable = function(lang, buf)
          local max_filesize = 10 * 1024 -- 10 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = true, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = "o",
          toggle_hl_groups = "i",
          toggle_injected_languages = "t",
          toggle_anonymous_nodes = "a",
          toggle_language_display = "I",
          focus_language = "f",
          unfocus_language = "F",
          update = "R",
          goto_node = "<cr>",
          show_help = "?",
        },
      },
      sync_install = true,
      indent = { enable = true, disable = { "toml", "yaml", "python", "css" } },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- MDX
      vim.filetype.add({
        extension = {
          mdx = "mdx",
        },
      })
      vim.treesitter.language.register("markdown", "mdx")
    end,
  },
}
