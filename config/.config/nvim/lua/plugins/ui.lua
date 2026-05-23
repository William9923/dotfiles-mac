local date_gen = io.popen('echo "$(date +%d)/$(date +%m)/$(date +%y) ($(date +%a )) $(date +%X)" | tr -d "\n"')
local date = date_gen:read("*a")
date_gen:close()

return {
  -- messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      table.insert(opts.routes, {
        filter = {
          any = {
            -- NOTE: add any annoying message here to filter from editor
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
            { find = "%d+ more lines" },
            { find = "%d+ fewer lines" },
            { find = "%d+ lines yanked" },
            { find = "gitsigns: Ignoring" }, -- haven't found fix yet, so quick workaround
            { find = "Invalid settings:" }, -- haven't found fix yet, so quick workaround -> for gopls
          },
        },
        view = "mini",
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })
      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })
      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })
      opts.presets.lsp_doc_border = true
      opts.presets.bottom_search = true
    end,
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 5000,
    },
  },

  -- buffer filename
  {
    "b0o/incline.nvim",
    dependencies = { "rebelot/kanagawa.nvim" },
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local kanagawa = require("kanagawa.colors").setup({ theme = "dragon" })
      local theme = kanagawa.theme
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal = { guibg = theme.syn.operator, guifg = theme.ui.bg },
            InclineNormalNC = { guifg = theme.syn.keyword, guibg = theme.ui.bg_m3 },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if vim.bo[props.buf].modified then
            filename = "[+] " .. filename
          end

          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },

  -- statusline (use default status line)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "rebelot/kanagawa.nvim" },
    event = "VeryLazy",
    opts = function(_, opts)
      local LazyVim = require("lazyvim.util")
      local kanagawa = require("kanagawa.colors").setup({ theme = "dragon" })
      local theme = kanagawa.theme
      opts.options = opts.options or {}
      opts.options.theme = {
        normal = {
          a = { bg = theme.syn.fun, fg = theme.ui.bg_m3 },
          b = { bg = theme.diff.change, fg = theme.syn.fun },
          c = { bg = theme.ui.bg_p1, fg = theme.ui.fg },
        },
        insert = {
          a = { bg = theme.diag.ok, fg = theme.ui.bg },
          b = { bg = theme.ui.bg, fg = theme.diag.ok },
        },
        command = {
          a = { bg = theme.syn.operator, fg = theme.ui.bg },
          b = { bg = theme.ui.bg, fg = theme.syn.operator },
        },
        visual = {
          a = { bg = theme.syn.keyword, fg = theme.ui.bg },
          b = { bg = theme.ui.bg, fg = theme.syn.keyword },
        },
        replace = {
          a = { bg = theme.syn.constant, fg = theme.ui.bg },
          b = { bg = theme.ui.bg, fg = theme.syn.constant },
        },
        inactive = {
          a = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          b = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim, gui = "bold" },
          c = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
        },
      }
      opts.sections.lualine_c[4] = {
        LazyVim.lualine.pretty_path({
          length = 0,
          relative = "cwd",
          modified_hl = "MatchParen",
          directory_hl = "",
          filename_hl = "Bold",
          modified_sign = "",
          readonly_icon = " 󰌾 ",
        }),
      }
    end,
  },

  -- dashboard
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      scroll = { enabled = false },
      dashboard = {
        pane_gap = 10,
        preset = {
          -- Used by the `header` section
          header = [[





    ██████╗ ██████╗ ██████╗ ███████╗
   ██╔════╝██╔═══██╗██╔══██╗██╔════╝
   ██║     ██║   ██║██║  ██║█████╗  
   ██║     ██║   ██║██║  ██║██╔══╝  
██╗╚██████╗╚██████╔╝██████╔╝███████╗
╚═╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝
    by: William Ong


      ]] .. "\nDate: " .. date .. "\n",
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "r", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        -- your dashboard configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        sections = {
          {
            pane = 2,
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = 'artprint -a colorowl2 -t "We don\'t sleep at night - Owls"',
            height = 12,
            ttl = 5 * 60,
            indent = 2,
            gap = 1,
            padding = 1,
          },
          { section = "header", gap = 2, padding = 1, height = 15 },
          { pane = 1, section = "keys", gap = 1, padding = 1 },
          { pane = 1, section = "startup" },
          {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short",
            height = 7,
            ttl = 5 * 60,
            indent = 2,
            gap = 1,
            padding = 1,
          },
          {
            pane = 2,
            icon = " ",
            title = "Git History",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git log --all --decorate --oneline --graph",
            height = 15,
            ttl = 5 * 60,
            indent = 2,
            gap = 1,
            padding = 1,
          },
        },
      },
    },
  },
}
