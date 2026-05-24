# Neovim Configuration

Personal Neovim configuration built on top of [LazyVim](https://www.lazyvim.org/). The config keeps LazyVim's maintained defaults, then layers on custom keymaps, language tooling, UI styling, picker behavior, formatting, and a small movement discipline helper.

## Documentation

- [Setup](docs/setup.md): prerequisites, install steps, and first launch notes.
- [Keymaps](docs/keymaps.md): custom mappings for editing, search, LSP, picker, and dashboard workflows.
- [Plugins](docs/plugins.md): plugin groups and the purpose of each local override.
- [Customization](docs/customization.md): common places to change colors, formatters, LSP servers, dashboard entries, and disabled plugins.
- [Screenshots](docs/screenshots.md): visual tour of the current UI.

## Current Shape

This configuration starts from `config.lazy`, imports LazyVim, enables a focused set of LazyVim extras, then loads local modules from `lua/plugins`.

Language extras:

- Go
- Python
- Rust
- Ruby
- Terraform
- Docker
- JSON
- TypeScript

Local additions:

- `fzf-lua` is the default picker.
- `solarized-osaka` is the main colorscheme.
- Kanagawa Dragon colors are reused for floating UI, file explorer, statusline, notifications, and picker surfaces.
- `conform.nvim` handles formatting.
- `neo-tree.nvim` provides file, buffer, git status, and document symbol browsing.
- `snacks.nvim` provides the startup dashboard.
- `noice.nvim` and `nvim-notify` handle command-line and notification UI.
- `nvim-cmp` remains the completion engine, while `blink.cmp` is disabled.
- A personal `dicipline` module warns when movement keys are repeated too much.

## Install

Back up any existing Neovim state first:

```sh
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

Use this config as `~/.config/nvim`:

```sh
ln -s /path/to/dotfiles/config/.config/nvim ~/.config/nvim
nvim
```

On first launch, `lazy.nvim` bootstraps itself and installs the plugin graph from `lazy-lock.json`.

## Requirements

Core tools:

- Neovim 0.10 or newer.
- Git.
- A terminal with true color support.
- A Nerd Font-compatible font for icons.

Recommended tools:

- `ripgrep` for search.
- `fd` for file discovery.
- `lazygit` for Git workflows.
- Language-specific tools installed through Mason or project-local package managers.

## Entry Points

- `init.lua` loads `lua/config/lazy.lua`.
- `lua/config/options.lua` contains editor defaults.
- `lua/config/keymaps.lua` contains global custom mappings.
- `lua/config/autocmds.lua` contains custom autocommands.
- `lua/plugins/*.lua` contains local LazyVim plugin overrides.
- `lua/personal/dicipline.lua` contains the movement-repeat warning helper.

## Maintenance

When changing behavior, update the matching page in `docs/` in the same commit. Prefer documenting the source file that owns the behavior instead of copying long Lua snippets into the README.
