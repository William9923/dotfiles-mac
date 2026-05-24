# Keymaps

Leader is `<Space>`. The config also maps `<Space>` to `<Nop>` first so it behaves only as the leader key.

## Navigation

| Key | Mode | Action |
| --- | --- | --- |
| `<C-h>` | Normal | Move to left window |
| `<C-j>` | Normal | Move to lower window |
| `<C-k>` | Normal | Move to upper window |
| `<C-l>` | Normal | Move to right window |
| `<C-d>` | Normal | Scroll down and center cursor |
| `<C-u>` | Normal | Scroll up and center cursor |
| `n` | Normal | Next search result and center cursor |
| `N` | Normal | Previous search result and center cursor |
| `.` | Normal, visual | Repeat `;` motion |

## Editing

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>h` | Normal | Clear search highlight |
| `<S-q>` | Normal | Delete current buffer with `Bdelete!` |
| `<C-a>` | Normal, visual | Select all |
| `r` | Normal | Enter replace mode |
| `+` | Normal | Increment number under cursor |
| `-` | Normal | Decrement number under cursor |
| `<CR>` | Normal, visual | Insert a newline without staying in insert mode |
| `kk` | Insert | Escape insert mode |
| `<` | Visual | Indent left and keep selection |
| `>` | Visual | Indent right and keep selection |
| `<S-j>` | Visual, visual block | Move selected text down |
| `<S-k>` | Visual, visual block | Move selected text up |

## Windows

These mappings still exist, though the config comments note that tmux navigation is the preferred workflow.

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>ss` | Normal | Horizontal split |
| `<leader>sv` | Normal | Vertical split |
| `<leader>sq` | Normal | Close split |

## Folding And Formatting

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>z` | Normal, visual | Set fold level from current indent |
| `<leader>ff` | Normal, visual | Force format through LazyVim formatting |

## Picker

The config sets `vim.g.lazyvim_picker = "fzf"` and uses `fzf-lua` for picker workflows.

| Key | Action |
| --- | --- |
| `;b` | Open buffers, sorted by most recently used |
| `;f` | Find files from the project root |
| `;gc` | Browse Git commits |
| `;gs` | Browse Git status |
| `;d` | Show document diagnostics |
| `;r` | Grep from the project root |
| `;k` | Browse keymaps |

## LSP

LazyVim's default LSP keymaps remain available unless overridden. This config adds or changes:

| Key | Mode | Action |
| --- | --- | --- |
| `gh` | Normal | Show LSP references through `fzf-lua` |
| `<leader>la` | Normal, visual | Code action |
| `<leader>lr` | Normal | Rename symbol |

The config disables LazyVim's default `<leader>ca` and `<leader>cr` LSP mappings so code action and rename live under `<leader>l`.

## Editor Plugins

| Key | Action |
| --- | --- |
| `<leader>a` | Toggle `outline.nvim` |
| `]]` | Go to next illuminated reference |
| `[[` | Go to previous illuminated reference |
| `;t` | Search TODO, FIX, and FIXME comments through fzf-lua |

## Dashboard

The startup dashboard is provided by `folke/snacks.nvim`.

| Key | Action |
| --- | --- |
| `f` | Find file |
| `r` | Find text |
| `x` | Open Lazy Extras |
| `l` | Open Lazy |
| `q` | Quit Neovim |

## Completion

`nvim-cmp` maps:

| Key | Mode | Action |
| --- | --- | --- |
| `<Tab>` | Insert, select | Select next completion item, trigger completion, or fallback |
| `<S-Tab>` | Insert, select | Select previous completion item or fallback |

Completion is disabled in prompt buffers, file tree buffers, and comments.
