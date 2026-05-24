# Customization

This page points to the files that own common customizations. Prefer changing the owning Lua module instead of adding one-off overrides elsewhere.

## Colorscheme

Main files:

- `lua/config/lazy.lua`
- `lua/plugins/colorscheme.lua`
- `lua/plugins/ui.lua`

The active LazyVim colorscheme is:

```lua
colorscheme = "solarized-osaka"
```

`lua/plugins/colorscheme.lua` loads `craftzdog/solarized-osaka.nvim` and uses Kanagawa Dragon colors to customize floating windows, Neo-tree, fzf-lua, Snacks dashboard, Noice, and Notify highlights.

To change the main colorscheme:

1. Add or enable the colorscheme plugin in `lua/plugins/colorscheme.lua`.
2. Change `colorscheme` in `lua/config/lazy.lua`.
3. Review highlight overrides that currently expect Solarized Osaka or Kanagawa color groups.

## Dashboard

Main file:

- `lua/plugins/ui.lua`

The dashboard is configured through `folke/snacks.nvim`.

Common changes:

- Edit `dashboard.preset.header` to change the ASCII header.
- Edit `dashboard.preset.keys` to change the dashboard actions.
- Edit `dashboard.sections` to add, remove, or resize panes.

The current dashboard shows:

- Header with timestamp.
- Shortcut keys for file search, text search, Lazy Extras, Lazy, and quit.
- Startup stats.
- Git status.
- Git history.
- Optional terminal art through `artprint`.

If `artprint` is not installed, the terminal-art section may fail or show nothing. Remove that section if you want the dashboard to avoid external commands.

## Picker

Main files:

- `lua/config/options.lua`
- `lua/plugins/finder.lua`

The default LazyVim picker backend is:

```lua
vim.g.lazyvim_picker = "fzf"
```

Custom picker keymaps are in `lua/plugins/finder.lua`. Add new fzf-lua workflows there so picker mappings stay grouped together.

## Formatting

Main files:

- `lua/plugins/formatting.lua`
- `lua/config/autocmds.lua`

`conform.nvim` owns formatters by filetype. Add or change entries in `formatters_by_ft`.

Examples:

```lua
formatters_by_ft = {
  lua = { "stylua" },
  go = { "goimports", "gofmt", stop_after_first = true },
}
```

Automatic formatting on save is currently limited to Go and Python through a `BufWritePre` autocommand in `lua/config/autocmds.lua`.

To add another autoformat filetype:

1. Make sure the formatter exists in `lua/plugins/formatting.lua`.
2. Add the matching pattern to the `BufWritePre` autocommand.
3. Ensure the formatter binary is installed through Mason or the project toolchain.

## LSP

Main file:

- `lua/plugins/lsp.lua`

Use this file for:

- Mason `ensure_installed` tools.
- LSP keymap overrides.
- Server-specific settings.
- Server setup workarounds.

Existing local server customizations include:

- `yamlls`: disables key ordering.
- `lua_ls`: uses Neovim runtime library when no project Lua config exists.
- `vtsls`: integrates Vue language server.
- `gopls`: uses `-tags=cgo` and a semantic tokens workaround.

## Treesitter

Main file:

- `lua/plugins/treesitter.lua`

Add parser names to `ensure_installed` when new languages need syntax support.

Indent is enabled globally, but disabled for:

- `toml`
- `yaml`
- `python`
- `css`

## Completion

Main file:

- `lua/plugins/cmp.lua`

Use this file to change:

- Completion icons.
- `<Tab>` and `<S-Tab>` behavior.
- Completion source order.
- Filetypes or contexts where completion should be disabled.

`blink.cmp` is disabled in `lua/plugins/disabled.lua`, so completion changes should target `nvim-cmp`.

## Comments

Main file:

- `lua/plugins/comments.lua`

`mini.comment` uses `<leader>/` for line, visual, and textobject comment mappings. It gets context-aware comment strings from Treesitter through `nvim-ts-context-commentstring`.

## File Explorer

Main file:

- `lua/plugins/editor.lua`

Neo-tree sources are:

- `filesystem`
- `buffers`
- `git_status`
- `document_symbols`

Change width, sources, or mappings in the Neo-tree spec. The config intentionally disables several default `o*` mappings and uses `o` for opening entries.

## Disabled Plugins

Main file:

- `lua/plugins/disabled.lua`

To re-enable a disabled plugin, remove the matching entry or set `enabled = true`. Review related config before re-enabling because some disabled plugins were replaced by active alternatives.

Examples:

- `blink.cmp` is disabled because the config uses `nvim-cmp`.
- `telescope-fzf-native.nvim` is disabled because the config uses `fzf-lua`.
- `bufferline.nvim` is disabled because tabline display is turned off.

## Personal Movement Warning

Main file:

- `lua/personal/dicipline.lua`

This module warns after repeated use of `j`, `k`, `h`, `l`, `+`, or `-` within a short window. It is enabled from `lua/config/lazy.lua`.

To tune it, adjust:

- `repeatMaxCounter`
- `durationWindowInMs`
- The key list inside `M.norepeat()`
