# macOS system defaults

`defaults.sh` sets **system preferences** (keyboard, Dock, Finder, screenshots) via `defaults write`. This is separate from dev dotfiles under `~/.config/`.

## On a new Mac

After `./setup.sh`:

```bash
cd ~/dotfiles
make macos-defaults
```

Preview without applying:

```bash
./macos/defaults.sh --dry-run
```

## Customize

Edit `defaults.sh` before running. Common tweaks:

| Goal | What to change |
|------|----------------|
| Hide hidden files in Finder | Set `AppleShowAllFiles` to `false` or comment out |
| Dock on the bottom | `orientation` → `bottom` |
| Different screenshot folder | `SCREENSHOT_DIR=~/Desktop ./macos/defaults.sh` |
| Skip menu bar seconds | Comment out the `menuextra.clock` block |

## Optional: run during bootstrap

```bash
DOTFILES_MACOS_DEFAULTS=1 ./setup.sh full
```

## Revert a single key

```bash
defaults delete com.apple.finder AppleShowAllFiles
killall Finder
```

Or reset a domain: `defaults delete com.apple.dock && killall Dock`
