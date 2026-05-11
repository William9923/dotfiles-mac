# Tyranitar Dotfiles

<p align="center"><img src="./docs/logo.png" height="220px" /></p>
<p align="center"><b>My personal macOS dev setup, managed with GNU Stow.</b></p>

<p align="center">
  <img alt="macOS" src="https://img.shields.io/badge/macOS-silver?style=flat-square&logo=apple" />
  <img alt="Shell" src="https://img.shields.io/badge/shell-zsh-1f6feb?style=flat-square&logo=gnubash" />
  <img alt="Editor" src="https://img.shields.io/badge/editor-neovim-019733?style=flat-square&logo=neovim" />
  <img alt="Multiplexer" src="https://img.shields.io/badge/multiplexer-tmux-1BB91F?style=flat-square&logo=tmux" />
  <img alt="Manager" src="https://img.shields.io/badge/manager-stow-blueviolet?style=flat-square" />
</p>

---

## ✨ Table of Contents

- [What's inside](#whats-inside)
- [Quick start](#quick-start)
- [Makefile cheat-sheet](#makefile-cheat-sheet)
- [How Stow works here](#how-stow-works-here)
- [Per-tool notes](#per-tool-notes)
- [Maintenance](#maintenance)
- [Known issues](#known-issues)

---

## What's inside

Everything in this repo mirrors a path under `$HOME`. When you `stow` the repo,
the files are symlinked into the right spots.

```
dotfiles/
├── Makefile                     ← run `make help` to see all commands
├── .stow-local-ignore           ← what stow skips
├── .zshrc                       → ~/.zshrc
├── .p10k.zsh                    → ~/.p10k.zsh        (powerlevel10k prompt)
├── .gitconfig                   → ~/.gitconfig
├── opencode.json                  (top-level opencode plugin config; ignored by stow)
├── .claude/
│   ├── CLAUDE.md                → ~/.claude/CLAUDE.md
│   └── settings.json            → ~/.claude/settings.json
└── .config/
    ├── alacritty/               → ~/.config/alacritty/
    ├── lazygit/config.yml       → ~/.config/lazygit/config.yml
    ├── nvim/                    → ~/.config/nvim/         (see notes)
    ├── opencode/command/        → ~/.config/opencode/command/
    ├── tmux/tmux.conf           → ~/.config/tmux/tmux.conf
    └── Cursor/User/             → ~/Library/Application Support/Cursor/User/
                                    (NOT stowed — linked via `make link-macos-apps`)
```

Anything in the repo root that **isn't** a real dotfile (`README.md`, `docs/`,
`Makefile`, `LICENSE`, the `~/` trash leftover, etc.) is excluded from stowing
via [`.stow-local-ignore`](./.stow-local-ignore). `.config/Cursor/` is also
excluded because Cursor reads from `~/Library/Application Support/...` on
macOS, not `~/.config/`.

---

## Quick start

```bash
# 1. Install Xcode CLT + Homebrew
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install the tools you need
brew install \
  stow git neovim tmux alacritty lazygit lazydocker \
  zsh atuin direnv git-delta gh gping kubectl kubecolor \
  fzf ripgrep fd bat eza \
  pyenv nvm rbenv bun

# Optional GUI casks
brew install --cask alacritty font-jetbrains-mono-nerd-font

# 3. Clone the repo so it lives at ~/dotfiles
git clone <this-repo> ~/dotfiles
cd ~/dotfiles

# 4. Sanity-check your toolchain, then symlink everything
make doctor          # verifies stow, brew, nvim, tmux, etc. are installed
make check           # dry-run — shows what would happen
make install         # creates the symlinks in $HOME
make link-macos-apps # links Cursor & friends into ~/Library/Application Support
make status          # confirms everything is in place

# 5. Install zsh plugins / themes (see Per-tool notes)
# 6. Open a new shell. Run `p10k configure` if you want to retune the prompt.
```

That's it — `~/.zshrc`, `~/.gitconfig`, `~/.config/nvim`, etc. are now symlinks
into this repo. Edit them anywhere; both paths point to the same file.

---

## Makefile cheat-sheet

Run `make help` for the live list. Common ones:

| Command                  | What it does                                                    |
| ------------------------ | --------------------------------------------------------------- |
| `make doctor`            | Verify `stow`, `brew`, `nvim`, `tmux`, etc. are installed.      |
| `make check`             | Dry-run — show what `make install` *would* do.                  |
| `make install`           | Symlink every tracked file into `$HOME` (idempotent).           |
| `make restow`            | Un-stow + re-stow. Use after adding/moving files in the repo.   |
| `make uninstall`         | Remove all symlinks this repo placed in `$HOME`.                |
| `make link-macos-apps`   | Symlink Cursor's settings/keybindings into Library/App Support. |
| `make adopt`             | **Destructive.** Move existing `$HOME` files *into* this repo, then symlink them back. Useful on a fresh machine when files already exist. Commit changes after. |
| `make status`            | Show which tracked files are correctly linked, drifted, or missing. |

---

## How Stow works here

This repo uses **one stow package = the entire `dotfiles/` directory**. The
stow dir is `$HOME` (because that's where `dotfiles/` lives), the target is
also `$HOME`, and the package name is `dotfiles`. The `Makefile` wraps all of
this so you don't have to remember the flags — but here's what it boils down to:

```bash
cd ~

# preview what stow would do (recommended first run)
stow -t ~ -nv dotfiles                 # = make check

# actually create the symlinks
stow -t ~ -v dotfiles                  # = make install

# remove all symlinks
stow -t ~ -Dv dotfiles                 # = make uninstall

# remove + re-stow (e.g. after restructuring or adding a file)
stow -t ~ -Rv dotfiles                 # = make restow
```

Files / dirs listed in [`.stow-local-ignore`](./.stow-local-ignore) are skipped
(currently: `README.md`, `LICENSE`, `Makefile`, `docs/`, `opencode.json`, the
stray `~/` folder, `.config/Cursor/`, plus things like `.git` and `.DS_Store`).

If stow refuses to link a file because something already exists at the target,
either back up the existing file (`mv ~/.zshrc ~/.zshrc.bak`) or run
`make adopt` (which **moves** the existing file *into* the repo — useful when
seeding the repo from a fresh machine, but commit immediately after so you can
see what got pulled in).

---

## Per-tool notes

### Zsh

The `.zshrc` expects these to live in `$HOME`:

```bash
git clone https://github.com/romkatv/powerlevel10k.git              ~/powerlevel10k
git clone https://github.com/romkatv/zsh-defer.git                  ~/zsh-defer
git clone https://github.com/agkozak/zsh-z.git                      ~/zsh-z
git clone https://github.com/zsh-users/zsh-autosuggestions.git      ~/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git  ~/.zsh/zsh-syntax-highlighting
```

Secrets (API keys, etc.) live in `~/.zsh_secrets` and are auto-sourced if
present. **Never** commit that file.

### Git

Uses [delta](https://github.com/dandavidson/delta) as pager and `nvim` as editor.
`git-lfs` filter is configured; install with `brew install git-lfs && git lfs install`.

The `[url ...]` blocks rewrite `https://github.com/` and
`https://source.golabs.io/` to SSH — make sure your SSH keys are loaded
(`ssh-add -K ~/.ssh/id_ed25519`).

### Neovim

The `init.lua` here boots LazyVim (`require("config.lazy")`), but the **active**
LazyVim plugin specs (`lua/config/`, `lua/plugins/`, `lua/personal/`) currently
live in `~/.config/nvim/` and are **not** tracked by this repo — they're local
to the machine. The `lua/user/` directory in this repo is leftover from the old
packer-based setup and is no longer used at runtime. See [Known issues](#known-issues).

### Tmux

```bash
# tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# then inside tmux: prefix + I  (capital i) to install plugins
```

### Alacritty

Config is still in the old `.yml` format. Alacritty ≥ 0.13 prefers `.toml`;
migrate when convenient with:

```bash
alacritty migrate
```

### Lazygit / Lazydocker

No setup beyond `brew install`. Config is already wired through stow.

### Atuin

```bash
atuin register   # or `atuin login` if you already have an account
atuin import auto
```

### Claude Code

- `.claude/CLAUDE.md` → `~/.claude/CLAUDE.md` (global "always-on" instructions)
- `.claude/settings.json` → `~/.claude/settings.json` (enabled plugins)

> ⚠️ The pre-existing `~/.claude/CLAUDE.md` symlink in this setup was created
> with a *relative* target (`dotfiles/.claude/CLAUDE.md`) that resolves to a
> non-existent path from `~/.claude/`'s perspective. Re-running `make restow`
> fixes it — stow places the correct relative path.

### Opencode

- Slash commands: `.config/opencode/command/` → `~/.config/opencode/command/`
- `opencode.json` at the repo root is **not** stowed (different schema, lives
  outside `$HOME`).
- `op` and `op-preset` shell helpers are defined in `.zshrc`. `op-preset`
  toggles `~/.config/opencode/oh-my-opencode-slim.json` between
  `tier-google`, `tier-opencode`, `tier-github`, `tier-antigravity`.

### Cursor (macOS)

Cursor stores user config under `~/Library/Application Support/Cursor/User/`,
not `~/.config/`, so stow can't place it from a `.config/Cursor/...` source.
The repo tracks the files at `.config/Cursor/User/`, and `make link-macos-apps`
creates the right symlinks:

```
~/Library/Application Support/Cursor/User/settings.json     → repo
~/Library/Application Support/Cursor/User/keybindings.json  → repo
```

The target is also added to `.stow-local-ignore` so a stray `make install`
won't create a useless `~/.config/Cursor/` directory.

### Language version managers

`.zshrc` initializes `pyenv`, `nvm`, `rbenv`, `gvm`, `bun`, and `pnpm` (most
lazy-loaded via `zsh-defer` so shell startup stays fast). Install whichever you
actually use; the missing ones will print a one-time warning on first shell start
but won't break anything.

---

## Maintenance

### Adding a new dotfile

1. Create the file at the path it would have under `$HOME`, but rooted inside
   this repo. For example, to manage `~/.config/ghostty/config`:

   ```bash
   mkdir -p ~/dotfiles/.config/ghostty
   mv ~/.config/ghostty/config ~/dotfiles/.config/ghostty/config
   ```

2. Re-stow and commit:

   ```bash
   make restow
   git add .config/ghostty && git commit -m "feat(ghostty): track config"
   ```

### Excluding files from being stowed

Add a pattern to [`.stow-local-ignore`](./.stow-local-ignore). Bare patterns
match the basename anywhere in the tree; `^/...$` patterns anchor to the repo
root. See the comments at the top of that file.

### Removing a dotfile

```bash
make uninstall                 # un-stow everything
rm dotfiles/path/inside/repo   # delete the file from the repo
make install                   # re-stow what remains
```

### Drift check

If something edited a config directly in `$HOME` instead of in the repo, `make
status` will surface it as `DRIFT`. You can then either:

- **Keep the repo version**: `make restow` (after `make uninstall` clears the
  drifted file), or
- **Promote the $HOME version**: `cp ~/<path> dotfiles/<path>` (or use
  `make adopt` to do this for *all* drift in one go — destructive, commit
  immediately after).

---

## Known issues

These exist in the repo today and are flagged here so you can clean them up
when you're ready. None block daily use; `make status` will help you spot
when each one matters.

### Repo cleanup

1. **`~/.local/share/Trash/...` is tracked in git** — a leftover from a typo in
   `.zshrc`:
   ```bash
   export GRAVEYARD="~/.local/share/Trash"   # ← `~` never expands; quoted
   ```
   Fix:
   ```bash
   git rm -r '~'                              # removes the stray dir from git
   # then in .zshrc:  export GRAVEYARD="$HOME/.local/share/Trash"
   ```
2. **`.config/tmux/plugins/*` is tracked** — these are `tpm`-managed plugin
   checkouts that should be installed at runtime, not committed.
   ```bash
   git rm -r --cached .config/tmux/plugins
   echo '.config/tmux/plugins/' >> .gitignore
   ```
3. **`.config/nvim/lua/user/`** — old packer config, no longer referenced by
   `init.lua` (which boots LazyVim). Safe to delete once you confirm nothing
   imports it.
4. **`.config/nvim/plugin/packer_compiled.lua`** — generated artifact from
   packer. Safe to delete.
5. **`.config/alacritty/catppuccin/`** — empty directory.

### Stow setup

6. **`~/.claude/CLAUDE.md` is a broken symlink**. The pre-existing link points
   to `dotfiles/.claude/CLAUDE.md` *relative to* `~/.claude/`, which doesn't
   exist. Fix: `make uninstall && make install` (stow will write the correct
   relative path).
7. **`~/.claude/settings.json` and `~/.config/opencode/command/*.md` have
   drifted** — they exist as real files in `$HOME`, not symlinks into this
   repo. You can either promote the `$HOME` version (`cp` into the repo) or
   replace it (back up `$HOME` version, then `make restow`).

### Shell / git config

8. **`.zshrc` minor bugs**:
   - `PATH="/opt/homebrew/Cellar:$PATH"` is a no-op — should be
     `/opt/homebrew/bin`.
   - `PATH="$PATH:$HOME/.cargo/env"` is wrong — `.cargo/env` is a script you
     `source`, not a directory; should be `$HOME/.cargo/bin`.
   - `alias ll` and `alias lla` are each defined twice (the first pair is
     dead).
   - `JAVA_HOME=$(/usr/libexec/java_home -v 1.8)` runs on every shell startup
     and prints a warning if Java 1.8 isn't installed.
9. **`.gitconfig`** — `editor = nvim` is set twice; indentation mixes tabs
   and spaces.

---

## ❤️ Credits

Original inspiration from various rice configs across r/unixporn. Tyranitar
because a great engineer's toolbox should be a little chunky and a lot
powerful. ⭐ this repo if it helped you build yours.
