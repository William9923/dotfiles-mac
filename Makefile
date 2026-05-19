# Tyranitar dotfiles — stow wrapper
#
# This Makefile drives GNU Stow so day-to-day operations stay short.
# The whole repo is treated as a single stow package: stow links every
# file/dir at the top level of this repo into $HOME, mirroring structure.
#
# Files excluded from stowing live in .stow-local-ignore.

# ── Config ─────────────────────────────────────────────────────────────
DOTFILES_DIR := $(shell pwd)
PACKAGE      := $(notdir $(DOTFILES_DIR))
STOW_DIR     := $(dir $(DOTFILES_DIR))
TARGET       := $(HOME)

STOW         ?= stow
STOW_FLAGS   := --dir=$(STOW_DIR) --target=$(TARGET) --verbose=1

.DEFAULT_GOAL := help

# ── Targets ────────────────────────────────────────────────────────────

.PHONY: help
help: ## Show this help
	@echo "Tyranitar dotfiles — stow-based setup"
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Repo:    $(DOTFILES_DIR)"
	@echo "Package: $(PACKAGE)"
	@echo "Target:  $(TARGET)"

.PHONY: doctor
doctor: ## Check prerequisites (stow, brew, common tools)
	@echo "Checking prerequisites…"
	@command -v $(STOW) >/dev/null 2>&1 && echo "  ✓ stow:  $$($(STOW) --version | head -1)" || { echo "  ✗ stow not found — run: brew install stow"; exit 1; }
	@command -v git    >/dev/null 2>&1 && echo "  ✓ git:   $$(git --version)"             || echo "  ✗ git not found"
	@command -v brew   >/dev/null 2>&1 && echo "  ✓ brew:  $$(brew --version | head -1)"  || echo "  ⚠ brew not found (recommended on macOS)"
	@command -v nvim   >/dev/null 2>&1 && echo "  ✓ nvim:  $$(nvim --version | head -1)"  || echo "  ⚠ nvim not found"
	@command -v tmux   >/dev/null 2>&1 && echo "  ✓ tmux:  $$(tmux -V)"                   || echo "  ⚠ tmux not found"
	@command -v zsh    >/dev/null 2>&1 && echo "  ✓ zsh:   $$(zsh --version)"             || echo "  ⚠ zsh not found"
	@command -v delta  >/dev/null 2>&1 && echo "  ✓ delta: $$(delta --version | head -1)" || echo "  ⚠ delta not found (used by git pager)"

.PHONY: check
check: ## Dry-run: show what `make install` would do without changing anything
	@echo "Dry-run from $(STOW_DIR) → $(TARGET) (package: $(PACKAGE))"
	@$(STOW) $(STOW_FLAGS) --no --simulate $(PACKAGE)

.PHONY: install
install: ## Symlink every tracked file into $HOME (idempotent)
	@echo "Stowing $(PACKAGE) → $(TARGET)…"
	@$(STOW) $(STOW_FLAGS) $(PACKAGE)
	@echo "Done."

.PHONY: restow
restow: ## Re-stow (unstow + stow) — useful after adding new files
	@echo "Re-stowing $(PACKAGE) → $(TARGET)…"
	@$(STOW) $(STOW_FLAGS) --restow $(PACKAGE)
	@echo "Done."

# ── Manual linker (stow-free fallback) ─────────────────────────────────
# stow 2.3.1 misbehaves when STOW_DIR == TARGET (both are $HOME here),
# emitting "skipping target which was current stow directory" and planning
# nothing. Use `make link` as a stow-free alternative — it walks the repo
# and creates one symlink per file, mirroring directory structure into $HOME.

# Files in the repo that should NEVER be linked into $HOME.
# Keep in sync with the `status` target below and with .stow-local-ignore.
LINK_FIND_EXCLUDES := \
	! -path './.git/*' \
	! -path './docs/*' \
	! -path './~/*' \
	! -path './.config/Cursor/*' \
	! -name '.stow-local-ignore' \
	! -name '.gitignore' \
	! -name '.gitattributes' \
	! -name '.DS_Store' \
	! -name 'README.md' \
	! -name 'LICENSE' \
	! -name 'Makefile' \
	! -name 'opencode.json' \
	! -name '.nvimlog'

.PHONY: link
link: ## Symlink every tracked file into $HOME without stow (picks up new files; pass DRY=1 to preview)
	@if [ "$(DRY)" = "1" ]; then echo "Linking $(DOTFILES_DIR) → $(TARGET)  [DRY RUN — no changes]"; \
	 else echo "Linking $(DOTFILES_DIR) → $(TARGET) (manual, no stow)…"; fi
	@cd $(DOTFILES_DIR) && find . -type f $(LINK_FIND_EXCLUDES) 2>/dev/null | \
		sed 's|^\./||' | sort | while read -r rel; do \
			src="$(DOTFILES_DIR)/$$rel"; \
			dst="$(TARGET)/$$rel"; \
			src_ino="$$(stat -Lf %i "$$src" 2>/dev/null)"; \
			dst_ino="$$(stat -Lf %i "$$dst" 2>/dev/null)"; \
			if [ -n "$$src_ino" ] && [ "$$src_ino" = "$$dst_ino" ]; then \
				: ; \
			elif [ -L "$$dst" ]; then \
				if [ "$(DRY)" = "1" ]; then echo "  ↻ would relink $$rel  (currently points elsewhere)"; \
				else ln -sfn "$$src" "$$dst" && echo "  ↻ $$rel  (relinked)"; fi; \
			elif [ -e "$$dst" ]; then \
				if [ "$(DRY)" = "1" ]; then echo "  ! would back up real file: $$rel"; \
				else ts=$$(date +%Y%m%d-%H%M%S); \
					mv "$$dst" "$$dst.bak.$$ts" && ln -s "$$src" "$$dst" && \
					echo "  ✓ $$rel  (existing file backed up as $$(basename "$$dst").bak.$$ts)"; \
				fi; \
			else \
				if [ "$(DRY)" = "1" ]; then echo "  + would link $$rel"; \
				else mkdir -p "$$(dirname "$$dst")" && ln -s "$$src" "$$dst" && echo "  + $$rel"; fi; \
			fi; \
		done
	@if [ "$(DRY)" = "1" ]; then echo "Dry run done — re-run without DRY=1 to apply."; \
	 else echo "Done. (silent entries = already correctly linked)"; fi

.PHONY: link-check
link-check: ## Preview what `make link` would do, without changing anything
	@$(MAKE) --no-print-directory link DRY=1

.PHONY: unlink
unlink: ## Remove every direct symlink this repo placed in $HOME (mirror of `link`)
	@echo "Unlinking $(DOTFILES_DIR) from $(TARGET)…"
	@cd $(DOTFILES_DIR) && find . -type f $(LINK_FIND_EXCLUDES) 2>/dev/null | \
		sed 's|^\./||' | sort | while read -r rel; do \
			src="$(DOTFILES_DIR)/$$rel"; \
			dst="$(TARGET)/$$rel"; \
			if [ -L "$$dst" ] && [ "$$(stat -Lf %i "$$src" 2>/dev/null)" = "$$(stat -Lf %i "$$dst" 2>/dev/null)" ]; then \
				rm "$$dst" && echo "  - $$rel"; \
			fi; \
		done
	@echo "Done."

.PHONY: adopt
adopt: ## DESTRUCTIVE: move existing files in $HOME into this repo, then symlink them back
	@echo "⚠ This will MOVE files from $(TARGET) into $(DOTFILES_DIR) for any conflicts."
	@echo "   Make sure your repo is committed/clean before continuing."
	@printf "Continue? [y/N] "; read ans; case "$$ans" in y|Y) ;; *) echo "Aborted."; exit 1 ;; esac
	@$(STOW) $(STOW_FLAGS) --adopt $(PACKAGE)
	@echo "Done. Review changes with: git status && git diff"

.PHONY: uninstall
uninstall: ## Remove all symlinks this repo placed in $HOME (leaves files in repo intact)
	@echo "Unstowing $(PACKAGE) from $(TARGET)…"
	@$(STOW) $(STOW_FLAGS) --delete $(PACKAGE)
	@echo "Done."

# ── macOS-specific Library/Application Support links ──────────────────
# Some apps (Cursor, VSCode, etc.) don't follow XDG on macOS, so stow can't
# place them in the right spot from a `.config/...` source. We link them
# manually here.

CURSOR_USER_DIR := $(HOME)/Library/Application Support/Cursor/User

.PHONY: link-macos-apps
link-macos-apps: ## Symlink macOS-app configs (Cursor, etc.) into Library/Application Support
	@echo "Linking macOS app configs…"
	@mkdir -p "$(CURSOR_USER_DIR)"
	@for f in settings.json keybindings.json; do \
		src="$(DOTFILES_DIR)/.config/Cursor/User/$$f"; \
		dst="$(CURSOR_USER_DIR)/$$f"; \
		if [ ! -e "$$src" ]; then \
			echo "  · $$f — no source in repo, skipping"; \
			continue; \
		fi; \
		if [ -L "$$dst" ] && [ "$$(readlink "$$dst")" = "$$src" ]; then \
			echo "  ✓ Cursor/$$f already linked"; \
		elif [ -e "$$dst" ] && [ ! -L "$$dst" ]; then \
			ts=$$(date +%Y%m%d-%H%M%S); \
			mv "$$dst" "$$dst.bak.$$ts"; \
			ln -s "$$src" "$$dst"; \
			echo "  ✓ Cursor/$$f linked (existing file backed up as $$dst.bak.$$ts)"; \
		else \
			ln -sfn "$$src" "$$dst"; \
			echo "  ✓ Cursor/$$f linked"; \
		fi; \
	done

.PHONY: status
status: ## Compare every tracked file with its $HOME counterpart (linked / drifted / missing)
	@echo "── Stowed files vs $(TARGET) ───────────────────────────────"
	@cd $(DOTFILES_DIR) && find . -type f \
		! -path './.git/*' \
		! -path './docs/*' \
		! -path './~/*' \
		! -path './.config/Cursor/*' \
		! -name '.stow-local-ignore' \
		! -name '.gitignore' \
		! -name '.gitattributes' \
		! -name 'README.md' \
		! -name 'LICENSE' \
		! -name 'Makefile' \
		! -name 'opencode.json' \
		! -name '.nvimlog' \
		2>/dev/null | sed 's|^\./||' | sort | while read -r rel; do \
			src="$(DOTFILES_DIR)/$$rel"; \
			target="$(TARGET)/$$rel"; \
			if [ ! -e "$$target" ]; then \
				echo "  · $$rel — missing in \$$HOME (broken symlink? run: make restow)"; \
			elif [ "$$(stat -Lf %i "$$src" 2>/dev/null)" = "$$(stat -Lf %i "$$target" 2>/dev/null)" ]; then \
				: ; \
			else \
				echo "  ✗ $$rel — DRIFT: \$$HOME copy is not this repo's file"; \
			fi; \
		done
	@echo "  (no entries above = every stowed file is correctly linked)"
	@echo ""
	@echo "── macOS app configs (link-macos-apps) ─────────────────────"
	@for f in settings.json keybindings.json; do \
		src="$(DOTFILES_DIR)/.config/Cursor/User/$$f"; \
		dst="$(CURSOR_USER_DIR)/$$f"; \
		if [ ! -e "$$src" ]; then continue; fi; \
		if [ -L "$$dst" ] && [ "$$(stat -Lf %i "$$src" 2>/dev/null)" = "$$(stat -Lf %i "$$dst" 2>/dev/null)" ]; then \
			echo "  ✓ Cursor/$$f"; \
		elif [ -e "$$dst" ]; then \
			echo "  ✗ Cursor/$$f — DRIFT (run: make link-macos-apps)"; \
		else \
			echo "  · Cursor/$$f — not linked (run: make link-macos-apps)"; \
		fi; \
	done
