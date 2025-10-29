EXT_NAME := klinke-studio-theme
EXT_VERSION := $(shell node -p "require('./package.json').version")
BUILD_DIR := dist
VSIX_FILE := $(BUILD_DIR)/$(EXT_NAME)-$(EXT_VERSION).vsix
VSCODE_EXTENSIONS_DIR ?= $(HOME)/.vscode/extensions
CURSOR_EXTENSIONS_DIR ?= $(HOME)/.cursor/extensions
VSCODE_INSTALL_PATH := $(VSCODE_EXTENSIONS_DIR)/$(EXT_NAME)-$(EXT_VERSION)
CURSOR_INSTALL_PATH := $(CURSOR_EXTENSIONS_DIR)/$(EXT_NAME)-$(EXT_VERSION)

.PHONY: format build install install-vscode install-cursor install-both

format:
	@npx prettier --write .

build: format
	@echo "Packaging $(EXT_NAME) $(EXT_VERSION) -> $(VSIX_FILE)"
	@mkdir -p "$(BUILD_DIR)"
	@npx @vscode/vsce package --out "$(VSIX_FILE)"
	@echo "VSIX created at $(VSIX_FILE)"

install-vscode: build
	@echo "Installing $(EXT_NAME) $(EXT_VERSION) to $(VSCODE_INSTALL_PATH)"
	@mkdir -p "$(VSCODE_EXTENSIONS_DIR)"
	@rm -rf "$(VSCODE_INSTALL_PATH)"
	@rsync -a \
		--exclude '.git/' \
		--exclude '.github/' \
		--exclude 'node_modules/' \
		--exclude '.vscode/' \
		--exclude 'Makefile' \
		--exclude '$(BUILD_DIR)/' \
		--exclude '*.vsix' \
		./ "$(VSCODE_INSTALL_PATH)"
	@echo "Done. Restart VS Code to pick up the theme."

install-cursor: build
	@echo "Installing $(EXT_NAME) $(EXT_VERSION) to $(CURSOR_INSTALL_PATH)"
	@mkdir -p "$(CURSOR_EXTENSIONS_DIR)"
	@rm -rf "$(CURSOR_INSTALL_PATH)"
	@rsync -a \
		--exclude '.git/' \
		--exclude '.github/' \
		--exclude 'node_modules/' \
		--exclude '.vscode/' \
		--exclude 'Makefile' \
		--exclude '$(BUILD_DIR)/' \
		--exclude '*.vsix' \
		./ "$(CURSOR_INSTALL_PATH)"
	@echo "Done. Restart Cursor to pick up the theme."

install-both: install-vscode install-cursor

install: install-both
