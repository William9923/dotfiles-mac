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
```

Each first-level package mirrors paths under `$HOME`. For example, `zsh/.zshrc` links to `~/.zshrc`, and `bin/.local/bin/sync-dots` links to `~/.local/bin/sync-dots`.

## Bootstrap

```bash
cd ~/dotfiles
./setup.sh          # minimal profile
./setup.sh full     # full personal/dev profile
```

`setup.sh` installs or verifies Xcode Command Line Tools, Homebrew, Git, GNU Stow, and `mas`; backs up filesystem conflicts; stows all packages; links Cursor settings into `~/Library/Application Support/Cursor/User`; then installs the selected Homebrew profile with the global Git config disabled so Homebrew HTTPS taps are not rewritten to SSH. Set `DOTFILES_SKIP_BREW_BUNDLE=1` to skip Brewfile installation for smoke tests.

## Homebrew Profiles

```bash
make bundle-install-minimal  # install homebrew/.Brewfile.minimal
make bundle-install-full     # install homebrew/.Brewfile.full
make bundle-dump             # refresh homebrew/.Brewfile.full from this host
```

`minimal` is the portable baseline for shell, Git, editor, tmux, and dotfiles sync. `full` is the non-company personal/dev setup. Keep company/private modules out of tracked Brewfiles; use an ignored local file such as `homebrew/.Brewfile.company.local` when needed.

## Daily Sync

After `setup.sh`, run this from anywhere:

```bash
sync-dots
```

The command pulls upstream with fast-forward safety, stages changed dotfiles, refuses sensitive-looking paths, commits with timestamp metadata, and pushes. It defaults to `origin main`; override with `DOTFILES_REMOTE` or `DOTFILES_BRANCH` when needed. It does not refresh Homebrew packages by default; set `DOTFILES_SYNC_BREW_BUNDLE=1` to dump this host into `homebrew/.Brewfile.full`, then prune unwanted or company-specific packages before committing.

## Verification

```bash
./test-bootstrap.sh
```

The Tart test clones `ghcr.io/cirruslabs/macos-sequoia-vanilla:latest` by default, boots a transient VM, waits for SSH, copies this repo into the VM, runs `setup.sh` with `DOTFILES_SKIP_BREW_BUNDLE=1`, checks required tools and symlinks, then deletes the VM. Override with `TART_IMAGE=ghcr.io/cirruslabs/macos-sequoia-base:latest ./test-bootstrap.sh` if you want a faster base image.

## Maintenance

```bash
make doctor          # check local tools
make check           # dry-run stow
make restow          # relink packages
make bundle-dump     # refresh homebrew/.Brewfile.full
make test-bootstrap  # run Tart verification
```

Never commit `.env`, credentials, private SSH keys, or machine-local secrets. Shell secrets should stay in `~/.zsh_secrets`, which is intentionally unmanaged.
