# Tyranitar dotfiles - GNU Stow package matrix

DOTFILES_DIR := $(shell pwd)
TARGET       := $(HOME)
STOW         ?= stow
PACKAGES     := zsh git homebrew bin config cursor claude vim ideavim commitizen pi
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
	@echo "Checking local tools..."
	@echo "Status lines start with 'required' or 'optional'; other messages come from local tool startup."
	@echo ""
	@missing=0; \
	if command -v git >/dev/null 2>&1; then \
		printf "  required  ok       %-5s %s\n" "git" "$$(git --version)"; \
	else \
		printf "  required  missing  %-5s install Xcode Command Line Tools or Homebrew git\n" "git"; \
		missing=1; \
	fi; \
	if command -v stow >/dev/null 2>&1; then \
		printf "  required  ok       %-5s %s\n" "stow" "$$(stow --version | awk 'NR==1 {print}')"; \
	else \
		printf "  required  missing  %-5s install GNU Stow before linking dotfiles\n" "stow"; \
		missing=1; \
	fi; \
	if command -v brew >/dev/null 2>&1; then \
		printf "  optional  ok       %-5s %s\n" "brew" "$$(brew --version | awk 'NR==1 {print}')"; \
	else \
		printf "  optional  missing  %-5s install Homebrew to use bundle targets\n" "brew"; \
	fi; \
	if command -v mas >/dev/null 2>&1; then \
		printf "  optional  ok       %-5s %s\n" "mas" "$$(mas version)"; \
	else \
		printf "  optional  missing  %-5s install mas to manage App Store apps\n" "mas"; \
	fi; \
	if command -v pi >/dev/null 2>&1; then \
		printf "  optional  ok       %-5s %s\n" "pi" "$$(pi --version 2>/dev/null | awk 'NR==1 {print}')"; \
	else \
		printf "  optional  missing  %-5s install pi (mise or npm) for the coding agent TUI\n" "pi"; \
	fi; \
	if command -v rtk >/dev/null 2>&1; then \
		printf "  optional  ok       %-5s %s\n" "rtk" "$$(rtk --version 2>/dev/null | awk 'NR==1 {print}')"; \
	else \
		printf "  optional  missing  %-5s install rtk for token-efficient shell/OpenCode/pi rewrites\n" "rtk"; \
	fi; \
	if command -v obsidian >/dev/null 2>&1; then \
		vault=$$(obsidian vault 2>/dev/null | awk '/^path/ {print $$2}'); \
		if [ -n "$$vault" ]; then \
			printf "  optional  ok       %-5s vault %s\n" "obsidian" "$$vault"; \
		else \
			printf "  optional  warn     %-5s CLI found but vault path unavailable\n" "obsidian"; \
		fi; \
	else \
		printf "  optional  missing  %-5s install obsidian CLI + Local REST API plugin\n" "obsidian"; \
	fi; \
	if [ -L "$(TARGET)/.pi/agent/settings.json" ]; then \
		printf "  optional  ok       %-5s settings.json linked from dotfiles\n" "pi-stow"; \
	else \
		printf "  optional  missing  %-5s run make restow (or make install) to link pi package\n" "pi-stow"; \
	fi; \
	echo ""; \
	if [ "$$missing" -eq 0 ]; then \
		echo "All required tools are available."; \
	else \
		echo "Missing required tools. Install them, then rerun make doctor."; \
		exit 1; \
	fi

.PHONY: check
check: ## Dry-run Stow package links
	@echo "Dry-running GNU Stow."
	@echo "No files will be changed."
	@echo ""
	@echo "Packages: $(PACKAGES)"
	@echo ""
	@echo "Stow may print 'WARNING: in simulation mode so not modifying filesystem.'; that is expected here."
	@echo ""
	@$(STOW) $(STOW_FLAGS) --no --simulate $(PACKAGES)
	@echo ""
	@echo "Dry run completed. No files were changed."
	@echo "Run 'make restow' to apply these links."

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
	@GIT_CONFIG_GLOBAL=/dev/null brew bundle install --file="$(BREWFILE)" --no-upgrade

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
	@mkdir -p "$(HOME)/Library/Application Support/lazygit"
	@src="$(DOTFILES_DIR)/config/.config/lazygit/config.yml"; \
	dst="$(HOME)/Library/Application Support/lazygit/config.yml"; \
	if [ -L "$$dst" ] || [ ! -e "$$dst" ]; then \
		ln -sfn "$$src" "$$dst"; \
		echo "linked lazygit/config.yml"; \
	else \
		echo "skip lazygit/config.yml: target exists and is not a symlink"; \
	fi

.PHONY: sync
sync: ## Run the global sync command from the repo copy
	@bin/.local/bin/sync-dots

.PHONY: test-bootstrap
test-bootstrap: ## Verify setup.sh in a transient Tart VM
	@./test-bootstrap.sh

.PHONY: macos-defaults
macos-defaults: ## Apply macos/defaults.sh (keyboard, Dock, Finder, screenshots)
	@chmod +x macos/defaults.sh
	@./macos/defaults.sh
