return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = function()
      return {
        -- find
        { ";b", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
        { ";f", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
        { "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
        -- git
        { ";gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
        { ";gs", "<cmd>FzfLua git_status<CR>", desc = "Status" },
        -- search
        { ";d", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
        { ";r", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
        { ";k", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
        -- { "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
        -- { "<leader>sG", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
      }
    end,
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
