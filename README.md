# Tyranitar Dotfiles

macOS development environment managed with GNU Stow, Homebrew Bundle, and Tart verification.

## Layout

```text
dotfiles/
  setup.sh                         # fresh-machine bootstrap
  test-bootstrap.sh                # Tart VM verification
  Makefile                         # local operator shortcuts
  .stow-local-ignore               # Stow exclusions

  zsh/
    .zshrc
    .zprofile
    .p10k.zsh

  git/
    .gitconfig
    .gitconfig.local.example
    .gitignore_global

  homebrew/
    .Brewfile                         # default minimal profile for brew bundle --global
    .Brewfile.minimal                 # portable baseline
    .Brewfile.full                    # curated personal/dev profile

  bin/
    .local/bin/sync-dots

  config/
    .config/...

  claude/
    .claude/...

  vim/
    .vimrc

  ideavim/
    .ideavimrc

  commitizen/
    .czrc
```

Each first-level package mirrors paths under `$HOME`. For example, `zsh/.zshrc` links to `~/.zshrc`, and `bin/.local/bin/sync-dots` links to `~/.local/bin/sync-dots`.

## Bootstrap

```bash
cd ~/dotfiles
./setup.sh          # minimal profile
./setup.sh full     # full personal/dev profile
```

`setup.sh` installs or verifies Xcode Command Line Tools, Homebrew, Git, GNU Stow, and `mas`; backs up filesystem conflicts; stows all packages; links Cursor settings into `~/Library/Application Support/Cursor/User`; then installs the selected Homebrew profile with the global Git config disabled so Homebrew HTTPS taps are not rewritten to SSH.

The tracked `~/.gitconfig` stays generic and includes `~/.gitconfig.local` for personal or company-specific identity and host rewrites. During interactive setup, `setup.sh` can create `~/.gitconfig.local` from `git/.gitconfig.local.example`; non-interactive runs skip the prompt.

## Homebrew Profiles

```bash
make bundle-install-minimal  # install homebrew/.Brewfile.minimal
make bundle-install-full     # install homebrew/.Brewfile.full
make bundle-dump             # refresh homebrew/.Brewfile.full from this host
```

`minimal` is the portable baseline for shell, Git, editor, tmux, and dotfiles sync. `full` is the non-company personal/dev setup. Keep company/private modules out of tracked Brewfiles; use an ignored local file such as `homebrew/.Brewfile.company.local` when needed.

## Runtime Tools

`mise` manages the default Bun, ghq, Node.js, Python, Ruby, Rust, and Go versions from `config/.config/mise/config.toml`. Shell startup activates `mise` directly, replacing the old `gvm`, `nvm`, `pyenv`, `rbenv`, and manual Bun setup.

## Commitizen

The full profile installs the Node `commitizen` CLI plus the `cz-conventional-changelog` adapter globally. The `commitizen/.czrc` stow package links `~/.czrc`, so `git cz` uses Conventional Commit prompts in repositories without their own Commitizen config.

## Daily Sync

After `setup.sh`, run this from anywhere:

```bash
sync-dots
```

The command pulls upstream with fast-forward safety, stages changed dotfiles, refuses sensitive-looking paths, commits with timestamp metadata, and pushes. It defaults to `origin main`; override with `DOTFILES_REMOTE` or `DOTFILES_BRANCH` when needed. It does not refresh Homebrew packages by default; set `DOTFILES_SYNC_BREW_BUNDLE=1` to dump this host into `homebrew/.Brewfile.full`, then prune unwanted or company-specific packages before committing.

## Verification

```bash
./test-bootstrap.sh minimal
./test-bootstrap.sh full
```

The Tart test clones pinned image `ghcr.io/cirruslabs/macos-sequoia-vanilla@sha256:e0a0d651b7aba2e6d8fae510b3b31c2b927d288384bcb1a32405768747ad9961` by default, boots a transient VM, waits for SSH, copies this repo into the VM, runs `setup.sh` with the selected profile, checks required tools and symlinks, then deletes the VM. If no profile is passed, it defaults to `minimal`. Override `TART_IMAGE` when you intentionally want to test against a newer or different image.

## Maintenance

```bash
make doctor          # check local tools
make check           # dry-run stow
make restow          # relink packages
make bundle-dump     # refresh homebrew/.Brewfile.full
make test-bootstrap  # run Tart verification
```

Never commit `.env`, credentials, private SSH keys, or machine-local secrets. Shell secrets should stay in `~/.zsh_secrets`, which is intentionally unmanaged.
