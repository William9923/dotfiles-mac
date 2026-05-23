return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = function()
      return {
        -- find
        { ";b", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
        { ";f", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
        -- git
        { ";gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
        { ";gs", "<cmd>FzfLua git_status<CR>", desc = "Status" },
        -- search
        { ";d", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
        { ";r", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
        { ";k", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
      }
    end,
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
