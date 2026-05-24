# Plugins

Plugins are managed by `lazy.nvim` through `lua/config/lazy.lua`. LazyVim provides the base distribution, while local overrides live in `lua/plugins/`.

## LazyVim Base

`lua/config/lazy.lua` imports LazyVim and these extras:

| Extra | Purpose |
| --- | --- |
| `lazyvim.plugins.extras.lang.go` | Go language support |
| `lazyvim.plugins.extras.lang.python` | Python language support |
| `lazyvim.plugins.extras.lang.rust` | Rust language support |
| `lazyvim.plugins.extras.lang.ruby` | Ruby language support |
| `lazyvim.plugins.extras.lang.terraform` | Terraform and HCL support |
| `lazyvim.plugins.extras.lang.docker` | Dockerfile and Docker Compose support |
| `lazyvim.plugins.extras.lang.json` | JSON tooling |
| `lazyvim.plugins.extras.lang.typescript` | TypeScript and JavaScript tooling |
| `lazyvim.plugins.extras.coding.nvim-cmp` | Use `nvim-cmp` completion |

The config sets LazyVim's colorscheme to `solarized-osaka`.

## UI

Configured in `lua/plugins/ui.lua` and `lua/plugins/colorscheme.lua`.

| Plugin | Purpose |
| --- | --- |
| `craftzdog/solarized-osaka.nvim` | Main colorscheme |
| `rebelot/kanagawa.nvim` | Color source for custom UI highlights |
| `folke/noice.nvim` | Command line, messages, and notification routing |
| `rcarriga/nvim-notify` | Notification UI |
| `b0o/incline.nvim` | Floating filename display |
| `nvim-lualine/lualine.nvim` | Statusline |
| `folke/snacks.nvim` | Dashboard and UI helpers |

The colorscheme override keeps the editor on Solarized Osaka, while using Kanagawa Dragon colors for floating windows, Neo-tree, fzf-lua, Snacks dashboard, Noice completion kinds, and notification borders.

## Finder

Configured in `lua/plugins/finder.lua`.

| Plugin | Purpose |
| --- | --- |
| `ibhagwan/fzf-lua` | File, grep, diagnostics, Git, and keymap picker |

`vim.g.lazyvim_picker = "fzf"` makes fzf-lua the default LazyVim picker backend.

## Editing

Configured in `lua/plugins/editor.lua`, `lua/plugins/coding.lua`, and `lua/plugins/comments.lua`.

| Plugin | Purpose |
| --- | --- |
| `nvim-neo-tree/neo-tree.nvim` | File explorer, buffers, Git status, and document symbols |
| `RRethy/vim-illuminate` | Highlight word references and jump between them |
| `folke/todo-comments.nvim` | Collect TODO, FIX, and FIXME comments |
| `hedyhli/outline.nvim` | Symbol outline |
| `nvim-mini/mini.comment` | Comment toggling |
| `JoosepAlviste/nvim-ts-context-commentstring` | Context-aware comment strings |

Neo-tree is customized to prefer `o` for opening entries and disables several default `o*` mappings that conflict with the desired workflow.

## Completion

Configured in `lua/plugins/cmp.lua`.

| Plugin | Purpose |
| --- | --- |
| `hrsh7th/nvim-cmp` | Completion engine |
| `hrsh7th/cmp-emoji` | Emoji completion source |

The config customizes completion icons, source order, `<Tab>` behavior, and disables completion in prompt buffers, tree buffers, and comments.

## LSP

Configured in `lua/plugins/lsp.lua`.

| Plugin | Purpose |
| --- | --- |
| `mason-org/mason.nvim` | External tool installer |
| `neovim/nvim-lspconfig` | LSP client configuration |

Mason ensures these tools are installed:

- `stylua`
- `luacheck`
- `shellcheck`
- `shfmt`
- `goimports`

Local LSP customizations:

- Inlay hints are enabled.
- YAML key ordering warnings are disabled.
- Lua language server is configured for Neovim runtime files when no project `.luarc` exists.
- `vtsls` is configured with Vue language server integration.
- `gopls` uses `-tags=cgo`.
- `gopls` gets a semantic tokens compatibility workaround.

## Formatting

Configured in `lua/plugins/formatting.lua`.

| Plugin | Purpose |
| --- | --- |
| `stevearc/conform.nvim` | Formatting engine |

Configured formatters:

| Filetype | Formatter |
| --- | --- |
| `lua` | `stylua` |
| `sh` | `shfmt` |
| `python` | `black`, `isort` |
| `javascript`, `javascriptreact` | `prettier`, `prettierd` |
| `typescript`, `typescriptreact` | `prettier`, `prettierd` |
| `rust` | `rustfmt` |
| `go` | `goimports`, `gofmt` |
| `sql` | `pg_format`, `sql_formatter` |
| `yaml` | `yamlfmt` |
| `ruby`, `eruby` | `rubyfmt`, `rubocop` |

Rubocop is configured to use `bin/rubocop` from the project root when available.

## Treesitter

Configured in `lua/plugins/treesitter.lua`.

The config installs parsers for common project languages, including Go, Python, Terraform, Ruby, TypeScript, Rust, SQL, HTML, CSS, JavaScript, JSON, Markdown, Bash, Lua, Vim, and Dockerfile.

MDX files are registered as `mdx` while using the Markdown parser.

## Tests

Configured in `lua/plugins/test.lua`.

| Plugin | Purpose |
| --- | --- |
| `nvim-neotest/neotest` | Test runner framework |
| `nvim-neotest/neotest-plenary` | Plenary test adapter |

The Go adapter is customized for table-driven tests and runs with `-count=1 -timeout=30s`.

## Disabled Plugins

Configured in `lua/plugins/disabled.lua`.

Disabled plugins include:

- `mini.ai`
- `which-key.nvim`
- `leap.nvim`
- `flash.nvim`
- `nvim-lint`
- `nvim-spectre`
- `aerial.nvim`
- `friendly-snippets`
- `bufferline.nvim`
- `mini.animate`
- `tokyonight.nvim`
- `catppuccin`
- `telescope-fzf-native.nvim`
- `mini.bufremove`
- `blink.cmp`

This keeps the active plugin set focused around fzf-lua, nvim-cmp, Neo-tree, Snacks, and the local UI choices.
