local kind_icons = {
  Text = "",
  Method = "",
  Function = "󰊕",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "󰯲",
  Interface = "",
  Module = "󰕳",
  Property = "",
  Unit = "",
  Value = "󰰫",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "󰉺",
  Copilot = "",
}

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
  "hrsh7th/nvim-cmp",
  lazy = true,
  dependencies = {
    "hrsh7th/cmp-emoji",
  },
  -- -@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")
    opts.mapping = vim.tbl_extend("force", opts.mapping, {
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
          cmp.select_next_item()
          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
          -- this way you will only jump inside the snippet region
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "i", "s" }),
    })
    opts.sources = cmp.config.sources({
      { name = "nvim_lsp", group_index = 0 },
      {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      },
    }, {
      { name = "nvim_lua" },
      { name = "path" },
      { name = "buffer" },
    })
    opts.formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        vim_item.kind = kind_icons[vim_item.kind]
        vim_item.menu = ({
          nvim_lsp = "",
          nvim_lua = "",
          buffer = "",
          path = "",
          emoji = "",
        })[entry.source.name]
        return vim_item
      end,
    }
    opts.enabled = function()
      local context_status_ok, context = pcall(require, "cmp.config.context")
      if not context_status_ok then
        return true -- NOTE: by default, we should always apply auto-completion
      end

      -- Disable autocomplete on prompt
      if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
        return false
      end

      -- Disable custom plugin autocompletion
      for _, filetype in pairs({ "vimwiki", "NeoTree", "NvimTree" }) do
        if vim.bo.filetype == filetype then
          return false
        end
      end

      -- Disable autocomplete on comments
      if vim.api.nvim_get_mode().mode == "c" then
        return true
      else
        return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
      end
    end
  end,
}
