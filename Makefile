# Tyranitar dotfiles - GNU Stow package matrix

DOTFILES_DIR := $(shell pwd)
TARGET       := $(HOME)
STOW         ?= stow
PACKAGES     := zsh git homebrew bin config claude vim ideavim
STOW_FLAGS   := --dir=$(DOTFILES_DIR) --target=$(TARGET) --verbose=1 --no-folding
BREW_PROFILE ?= minimal
BREWFILE     := $(DOTFILES_DIR)/homebrew/.Brewfile.$(BREW_PROFILE)

.DEFAULT_GOAL := help

.PHONY: help
help: ## Show this help
	@echo "Tyranitar dotfiles"
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "Packages: $(PACKAGES)"
	@echo "Default Homebrew profile: $(BREW_PROFILE)"

.PHONY: doctor
doctor: ## Check required local tooling
	@command -v git >/dev/null 2>&1 && echo "  ok git:  $$(git --version)" || { echo "  missing git"; exit 1; }
	@command -v stow >/dev/null 2>&1 && echo "  ok stow: $$(stow --version | awk 'NR==1 {print}')" || { echo "  missing stow"; exit 1; }
	@command -v brew >/dev/null 2>&1 && echo "  ok brew: $$(brew --version | awk 'NR==1 {print}')" || echo "  missing brew"
	@command -v mas >/dev/null 2>&1 && echo "  ok mas:  $$(mas version)" || echo "  missing mas"

.PHONY: check
check: ## Dry-run Stow package links
	@$(STOW) $(STOW_FLAGS) --no --simulate $(PACKAGES)

.PHONY: install
install: ## Link all Stow packages into HOME
	@$(STOW) $(STOW_FLAGS) $(PACKAGES)

.PHONY: restow
restow: ## Re-link all Stow packages
	@$(STOW) $(STOW_FLAGS) --restow $(PACKAGES)

.PHONY: uninstall
uninstall: ## Remove Stow-managed symlinks
	@$(STOW) $(STOW_FLAGS) --delete $(PACKAGES)

.PHONY: adopt
adopt: ## Adopt existing HOME files into packages, then link
	@echo "This mutates package files with HOME conflicts. Ensure a backup exists first."
	@printf "Continue? [y/N] "; read ans; case "$$ans" in y|Y) ;; *) echo "Aborted."; exit 1 ;; esac
	@$(STOW) $(STOW_FLAGS) --adopt $(PACKAGES)

.PHONY: bundle-dump
bundle-dump: ## Refresh homebrew/.Brewfile.full from host state, then prune before committing
	@brew bundle dump --file="$(DOTFILES_DIR)/homebrew/.Brewfile.full" --force --describe

.PHONY: setup-minimal
setup-minimal: ## Bootstrap with the minimal Homebrew profile
	@./setup.sh minimal

.PHONY: setup-full
setup-full: ## Bootstrap with the full Homebrew profile
	@./setup.sh full

.PHONY: bundle-install
bundle-install: ## Install packages from homebrew/.Brewfile.$(BREW_PROFILE)
	@GIT_CONFIG_GLOBAL=/dev/null brew bundle install --file="$(BREWFILE)" --no-lock --no-upgrade

.PHONY: bundle-install-minimal
bundle-install-minimal: ## Install packages from the minimal Brewfile
	@$(MAKE) bundle-install BREW_PROFILE=minimal

.PHONY: bundle-install-full
bundle-install-full: ## Install packages from the full Brewfile
	@$(MAKE) bundle-install BREW_PROFILE=full

.PHONY: link-macos-apps
link-macos-apps: ## Link app configs that do not use XDG paths on macOS
	@mkdir -p "$(HOME)/Library/Application Support/Cursor/User"
	@for f in settings.json keybindings.json; do \
		src="$(DOTFILES_DIR)/config/.config/Cursor/User/$$f"; \
		dst="$(HOME)/Library/Application Support/Cursor/User/$$f"; \
		[ -e "$$src" ] || continue; \
		if [ -L "$$dst" ] || [ ! -e "$$dst" ]; then \
			ln -sfn "$$src" "$$dst"; \
			echo "linked Cursor/$$f"; \
		else \
			echo "skip Cursor/$$f: target exists and is not a symlink"; \
		fi; \
	done

.PHONY: sync
sync: ## Run the global sync command from the repo copy
	@bin/.local/bin/sync-dots

.PHONY: test-bootstrap
test-bootstrap: ## Verify setup.sh in a transient Tart VM
	@./test-bootstrap.sh
