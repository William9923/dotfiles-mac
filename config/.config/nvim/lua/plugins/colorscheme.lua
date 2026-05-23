return {
  {
    "craftzdog/solarized-osaka.nvim",
    dependencies = { "rebelot/kanagawa.nvim" },
    lazy = false,
    priority = 1000,
    opts = function()
      local function kanagawa_dragon()
        local ok, colors = pcall(function()
          return require("kanagawa.colors").setup({ theme = "dragon" })
        end)
        return ok and colors or nil
      end

      return {
        transparent = false,
        on_highlights = function(hl)
          local kanagawa = kanagawa_dragon()
          if not kanagawa then
            return
          end

          local theme = kanagawa.theme
          local palette = kanagawa.palette
          local ui = theme.ui
          local syn = theme.syn
          local diag = theme.diag
          local vcs = theme.vcs

          -- Keep the editor on Solarized Osaka, but give side UI a Kanagawa Dragon surface.
          hl.NormalFloat = { fg = ui.float.fg, bg = ui.float.bg }
          hl.FloatBorder = { fg = ui.float.fg_border, bg = ui.float.bg_border }
          hl.FloatTitle = { fg = syn.identifier, bg = ui.float.bg }
          hl.Pmenu = { fg = ui.pmenu.fg, bg = ui.pmenu.bg }
          hl.PmenuSel = { fg = ui.pmenu.fg_sel, bg = ui.pmenu.bg_sel }
          hl.PmenuSbar = { bg = ui.pmenu.bg_sbar }
          hl.PmenuThumb = { bg = ui.pmenu.bg_thumb }

          hl.NeoTreeNormal = { fg = ui.fg_dim, bg = ui.bg_m3 }
          hl.NeoTreeNormalNC = { fg = ui.fg_dim, bg = ui.bg_m3 }
          hl.NeoTreeDimText = { fg = ui.nontext }
          hl.NeoTreeMessage = { fg = ui.nontext }
          hl.NeoTreeRootName = { fg = syn.identifier, bold = true }
          hl.NeoTreeDirectoryName = { fg = syn.fun }
          hl.NeoTreeDirectoryIcon = { fg = syn.fun }
          hl.NeoTreeFileName = { fg = ui.fg }
          hl.NeoTreeFileNameOpened = { fg = syn.special1, italic = true }
          hl.NeoTreeGitModified = { fg = vcs.changed }
          hl.NeoTreeGitAdded = { fg = vcs.added }
          hl.NeoTreeGitDeleted = { fg = vcs.removed }
          hl.NeoTreeGitStaged = { fg = vcs.added }
          hl.NeoTreeGitConflict = { fg = diag.error }
          hl.NeoTreeIndentMarker = { fg = ui.nontext }
          hl.NeoTreeWinSeparator = { fg = ui.bg_p1, bg = ui.bg_m3 }

          hl.FzfLuaNormal = { fg = ui.fg, bg = ui.float.bg }
          hl.FzfLuaBorder = { fg = ui.float.fg_border, bg = ui.float.bg }
          hl.FzfLuaTitle = { fg = syn.operator, bg = ui.float.bg }
          hl.FzfLuaPreviewTitle = { fg = syn.fun, bg = ui.float.bg }
          hl.FzfLuaHeaderText = { fg = syn.identifier, bg = ui.float.bg }
          hl.FzfLuaHeaderBind = { fg = syn.operator, bg = ui.float.bg }
          hl.FzfLuaFzfCursorLine = { bg = ui.bg_p1 }
          hl.FzfLuaCursor = { fg = ui.bg, bg = syn.operator }
          hl.FzfLuaPath = { fg = syn.fun }

          hl.SnacksPickerBorder = { fg = ui.float.fg_border, bg = ui.float.bg }
          hl.SnacksPickerPreviewTitle = { fg = syn.fun, bg = ui.float.bg }
          hl.SnacksDashboardHeader = { fg = syn.fun }
          hl.SnacksDashboardDesc = { fg = syn.special1 }
          hl.SnacksDashboardKey = { fg = syn.operator }
          hl.SnacksDashboardIcon = { fg = syn.special1, bold = true }
          hl.SnacksDashboardSpecial = { fg = syn.identifier }
          hl.SnacksDashboardFooter = { fg = syn.comment, italic = true }

          hl.NoiceCompletionItemKindDefault = { fg = ui.fg_dim, bg = "NONE" }

          hl.NotifyBackground = { bg = ui.bg }
          for _, level in ipairs({ "ERROR", "WARN", "INFO", "HINT", "DEBUG", "TRACE" }) do
            hl["Notify" .. level .. "Body"] = { fg = ui.fg, bg = ui.bg }
          end
          hl.NotifyERRORBorder = { fg = diag.error, bg = ui.bg }
          hl.NotifyWARNBorder = { fg = diag.warning, bg = ui.bg }
          hl.NotifyINFOBorder = { fg = diag.info, bg = ui.bg }
          hl.NotifyHINTBorder = { fg = diag.hint, bg = ui.bg }
          hl.NotifyDEBUGBorder = { fg = ui.nontext, bg = ui.bg }
          hl.NotifyTRACEBorder = { fg = palette.dragonViolet, bg = ui.bg }
        end,
      }
    end,
  },
}
