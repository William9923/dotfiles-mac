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
      opts.presets.lsp_doc_border = false
      opts.presets.bottom_search = true
    end,
  },

  -- buffer filename
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    priority = 1200,
    config = function()
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal = { guibg = "cyan", guifg = "black" },
            InclineNormalNC = { guifg = "magenta", guibg = "black" },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
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
    event = "VeryLazy",
    opts = {
      options = {
        theme = "kanagawa",
      },
    },
  },

  -- dashboard
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
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
