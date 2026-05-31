# (Work) Dotfiles

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
    .config/
      aerospace/                 # AeroSpace window manager (aerospace.toml)
      alacritty/
      mise/
      nvim/
      tmux/
      ...

  claude/
    .claude/...

  vim/
    .vimrc

  ideavim/
    .ideavimrc

  commitizen/
    .czrc

  macos/
    defaults.sh                    # optional system prefs (keyboard, Dock, Finder)
    README.md

  cursor-templates/
    mcp.json.example               # copy to ~/.cursor/mcp.json on new Mac

  zsh/
    .zsh_secrets.example           # copy to ~/.zsh_secrets (never commit)
```

Each first-level package mirrors paths under `$HOME`. For example, `zsh/.zshrc` links to `~/.zshrc`, and `bin/.local/bin/sync-dots` links to `~/.local/bin/sync-dots`.

## Setting up a new Mac

Use this checklist when moving to a fresh macOS machine. The automated script covers most of the shell, Git, editor, and Homebrew baseline; secrets and a few tools still need manual steps.

### Before you start

- Sign in to iCloud and complete the macOS setup assistant.
- Install nothing extra yet beyond what Apple provides — `setup.sh` installs Xcode Command Line Tools and Homebrew for you.
- Have your dotfiles remote URL and SSH key (or HTTPS credentials) ready.
- Copy machine-local secrets from a password manager or your old Mac (see [Secrets and machine-local files](#secrets-and-machine-local-files)).

### 1. Clone dotfiles

```bash
git clone <your-dotfiles-remote> ~/dotfiles
cd ~/dotfiles
```

Use the branch you normally work from (for example `main` or `work`):

```bash
git checkout work   # optional
```

### 2. Run bootstrap

Pick a Homebrew profile:

| Profile | Command | Use when |
|---------|---------|----------|
| **minimal** | `./setup.sh` or `./setup.sh minimal` | Portable shell, Git, Neovim, tmux, and core CLI only |
| **full** | `./setup.sh full` | Personal/dev machine (Docker/Colima, K8s CLIs, Cursor casks, language tooling) |

`setup.sh` on macOS will:

1. Install or verify **Xcode Command Line Tools**
2. Install **Homebrew** if missing
3. Install **git**, **stow**, and **mas**
4. Back up any conflicting files under `~/.dotfiles-backups/<timestamp>-setup/`
5. **Stow** all packages into `$HOME`
6. Symlink **Cursor** `settings.json` and `keybindings.json` into `~/Library/Application Support/Cursor/User/`
7. Symlink **lazygit** and **lazydocker** configs into `~/Library/Application Support/`
8. Optionally create `~/.gitconfig.local` from the template (interactive prompt only)
9. Run `brew bundle install` for the selected profile
10. Run `mise install -y` from `~/.config/mise/config.toml`

Non-interactive runs (CI, scripts) skip the `~/.gitconfig.local` prompt — create that file yourself afterward.

### 3. Open a new shell

```bash
exec zsh -l
# or
source ~/.zshrc
```

Confirm tools resolve:

```bash
make doctor
which git stow brew mise nvim
```

### 4. Post-setup (manual)

Complete these after `setup.sh` finishes. They are intentionally **not** committed to the repo.

#### Git identity and auth

```bash
cp ~/dotfiles/git/.gitconfig.local.example ~/.gitconfig.local
chmod 600 ~/.gitconfig.local
# Edit name, email, and any [url] rewrites for work hosts
```

```bash
gh auth login          # recommended over plain credential store
ssh-keygen -t ed25519  # if you need a new SSH key; add the public key to GitHub/GitLab
```

#### Shell secrets

```bash
cp ~/dotfiles/zsh/.zsh_secrets.example ~/.zsh_secrets
chmod 600 ~/.zsh_secrets
# Add CURSOR_API_KEY, OBSIDIAN_MCP_TOKEN, etc. (see zsh/.zsh_secrets.example)
```

Reload: `source ~/.zshrc`

#### tmux plugin manager (TPM)

tmux config expects TPM at `~/.tmux/plugins/tpm`:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Inside tmux, press `prefix + I` to install plugins, or start a new tmux session after cloning.

#### AeroSpace (full profile)

Installed via `.Brewfile.full` (`aerospace` cask + `borders` for active-window highlight). Config is stowed to `~/.config/aerospace/aerospace.toml`:

```bash
# After ./setup.sh full — grant Accessibility if macOS prompts
open -a AeroSpace
```

Reload config from AeroSpace service mode: `alt-shift-;` then `esc`, or restart the app.

#### Shell history (atuin)

Included in both Brew profiles. Register the new machine:

```bash
atuin register
# follow prompts; sync if you use atuin cloud
```

#### Language runtimes (mise)

`setup.sh` installs tools from `config/.config/mise/config.toml`. To refresh later:

```bash
mise install
mise doctor
```

Prefer **mise** on new machines; do not reinstall legacy `nvm`, `gvm`, or `pyenv` unless a project requires them.

#### Docker (full profile only)

Colima is in `.Brewfile.full`. Start a VM and confirm the socket matches `.zshrc`:

```bash
colima start
docker ps
```

`.zshrc` sets `DOCKER_HOST` to `unix://$HOME/.colima/true/docker.sock`. If your Colima profile name differs, update `.zshrc` or create a profile named `true`.

#### Optional company Homebrew bundle

For work-only formulas and casks, use a **gitignored** local file (never commit secrets or private taps):

```bash
# homebrew/.Brewfile.company.local  (create locally; see .gitignore)
GIT_CONFIG_GLOBAL=/dev/null brew bundle install --file=~/dotfiles/homebrew/.Brewfile.company.local
```

#### Cursor and AI tooling

- Sign in to **Cursor**; install extensions you rely on.
- Copy MCP config from template: `cp ~/dotfiles/cursor-templates/mcp.json.example ~/.cursor/mcp.json` then edit (see [Cursor vs OpenCode](#cursor-vs-opencode)).
- **OpenCode**: tracked under `config/.config/opencode/`; auth in `~/.config/opencode/antigravity-accounts.json` stays local (gitignored).
- **Claude Code**: tracked settings live in `claude/.claude/`; sign in on the new machine as needed.

#### Cloud and cluster access

Re-authenticate per provider (not stored in dotfiles):

```bash
# examples — run only what you use
aws configure sso    # or copy ~/.aws from secure backup
gcloud init
kubectl config       # merge kubeconfigs from secure backup
```

### 5. macOS system feel (optional)

Apply keyboard, Dock, Finder, and screenshot defaults (see `macos/README.md`):

```bash
cd ~/dotfiles
make macos-defaults
# or preview: ./macos/defaults.sh --dry-run
```

Or during bootstrap:

```bash
DOTFILES_MACOS_DEFAULTS=1 ./setup.sh full
```

### 6. Secrets and templates

```bash
# Shell secrets for OpenCode {env:VAR}
cp ~/dotfiles/zsh/.zsh_secrets.example ~/.zsh_secrets
chmod 600 ~/.zsh_secrets
# Edit: CURSOR_API_KEY, OBSIDIAN_MCP_TOKEN, etc.

# Cursor MCP (not stowed; no {env:...} syntax in mcp.json)
cp ~/dotfiles/cursor-templates/mcp.json.example ~/.cursor/mcp.json
chmod 600 ~/.cursor/mcp.json
# Edit URLs and Authorization headers
```

Reload the shell: `source ~/.zshrc`

### 7. Verify

```bash
cd ~/dotfiles
make doctor
make check           # dry-run stow; expect "simulation mode" warning
./test-bootstrap.sh minimal   # optional: Tart VM smoke test
```

Sanity checks:

```bash
test -L ~/.zshrc && test -L ~/.gitconfig
tmux -V && nvim --version
```

### Quick reference (copy-paste)

```bash
git clone <your-dotfiles-remote> ~/dotfiles && cd ~/dotfiles
./setup.sh full
exec zsh -l
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
make macos-defaults
cp ~/dotfiles/zsh/.zsh_secrets.example ~/.zsh_secrets && chmod 600 ~/.zsh_secrets
cp ~/dotfiles/cursor-templates/mcp.json.example ~/.cursor/mcp.json && chmod 600 ~/.cursor/mcp.json
# then: edit secrets, gitconfig.local, gh auth, atuin register, colima start, Cursor sign-in
```

### Secrets and machine-local files

Never commit these. Restore from a password manager or encrypted backup:

| File | Purpose |
|------|---------|
| `~/.zsh_secrets` | Shell environment secrets |
| `~/.gitconfig.local` | Git user identity and host rewrites |
| `~/.ssh/` | SSH keys and `config` |
| `~/.git-credentials` | Legacy credential store (prefer `gh auth`) |
| `~/.netrc`, `~/.npmrc` | HTTP/registry tokens |
| `~/.aws/`, `~/.config/gcloud/` | Cloud CLI credentials |
| `~/.config/gh/hosts.yml` | `gh` authentication |
| `~/.config/opencode/antigravity-accounts.json` | OpenCode auth |
| `~/.cursor/mcp.json` | Cursor MCP servers (often contains API keys) |

Optional local Brewfile: `homebrew/.Brewfile.company.local`, `homebrew/.Brewfile.local` (both gitignored).

## Bootstrap

See [Setting up a new Mac](#setting-up-a-new-mac) for the full walkthrough. Short form:

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

**Policy:** `.Brewfile.full` stays a **lean curated** list (~90 lines), not a dump of everything on this Mac. A new machine should get a sane dev baseline, not every experiment or work-only tool installed here. Use `make bundle-dump` only to *compare* against the host, then cherry-pick into `full` or a gitignored `.Brewfile.local`.

## Cursor vs OpenCode

Both tools split config the same way: **portable settings in dotfiles**, **secrets and runtime state on the machine**.

| | **Cursor** | **OpenCode** |
|---|------------|--------------|
| **Editor / app preferences** | `config/.config/Cursor/User/settings.json`, `keybindings.json` → symlinked to `~/Library/Application Support/Cursor/User/` by `setup.sh` | N/A (CLI/TUI) |
| **Main config file** | No single `opencode.json` equivalent in dotfiles for the IDE | `config/.config/opencode/opencode.json` (stowed to `~/.config/opencode/`) |
| **Commands / skills** | Cursor rules/skills live under `~/.cursor/` (plugins, not stowed) | `config/.config/opencode/commands/`, `skills/` |
| **Secrets** | `~/.cursor/mcp.json`, `cli-config.json`, extension state — **not** in repo | `{env:VAR}` in `opencode.json` where supported; `antigravity-accounts.json` gitignored |
| **Templates** | `cursor-templates/mcp.json.example` → copy to `~/.cursor/mcp.json` | Use `{env:...}` in tracked JSON; set vars in `~/.zsh_secrets` |

OpenCode supports `{env:VAR}` in config (e.g. `CURSOR_API_KEY`, `OBSIDIAN_MCP_TOKEN`). Cursor’s `mcp.json` does **not** use that syntax — copy the template and paste tokens locally, or keep `~/.cursor/mcp.json` only on the machine / in a password manager.

```bash
cp ~/dotfiles/cursor-templates/mcp.json.example ~/.cursor/mcp.json
chmod 600 ~/.cursor/mcp.json
# Edit URLs and Authorization headers; do not commit ~/.cursor/mcp.json
```

## macOS system defaults (optional)

`macos/defaults.sh` applies **`defaults write`** settings for keyboard repeat, Dock (autohide, left, no MRU spaces), Finder path bar, screenshot folder (`~/Pictures/Screenshots`), and menu bar clock. Values are seeded from this repo’s primary Mac; edit the script before running if you want different behavior.

```bash
make macos-defaults              # apply
./macos/defaults.sh --dry-run    # preview commands only
```

Details and customization: `macos/README.md`. Not run automatically unless `DOTFILES_MACOS_DEFAULTS=1 ./setup.sh`.

## Runtime Tools

`mise` manages the default Bun, ghq, Node.js, Python, Ruby, Rust, and Go versions from `config/.config/mise/config.toml`. Shell startup activates `mise`, replacing the old `gvm`, `nvm`, `pyenv`, `rbenv`, and manual Bun setup.

`setup.sh` runs `mise install -y` after the selected Homebrew bundle is installed. In an existing shell, reload zsh first:

```bash
source ~/.zshrc
mise install
```

## Commitizen

The full profile installs the Node `commitizen` CLI plus the `cz-conventional-changelog` adapter globally. The `commitizen/.czrc` stow package links `~/.czrc`, so `git cz` uses Conventional Commit prompts in repositories without their own Commitizen config.

## Manual Sync

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

`make doctor` reports required tools first and exits non-zero only when a required tool is missing. `brew` and `mas` are shown as optional because they are only needed for Homebrew bundle and App Store package management:

```text
Checking local tools...

  required  ok       git   git version 2.46.0
  required  ok       stow  stow (GNU Stow) version 2.3.1
  optional  ok       brew  Homebrew 5.1.14
  optional  ok       mas   7.0.0

All required tools are available.
```

`make check` is a Stow dry run. The Stow warning `WARNING: in simulation mode so not modifying filesystem.` is expected and means no files were changed. If the dry run succeeds, apply the links with `make restow`.

Never commit `.env`, credentials, private SSH keys, or machine-local secrets. Shell secrets should stay in `~/.zsh_secrets`, which is intentionally unmanaged.
