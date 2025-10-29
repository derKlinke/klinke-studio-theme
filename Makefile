EXT_NAME := klinke-studio-theme
EXT_VERSION := $(shell node -p "require('./package.json').version")
BUILD_DIR := dist
VSIX_FILE := $(BUILD_DIR)/$(EXT_NAME)-$(EXT_VERSION).vsix
VSCODE_EXTENSIONS_DIR ?= $(HOME)/.vscode/extensions
INSTALL_PATH := $(VSCODE_EXTENSIONS_DIR)/$(EXT_NAME)-$(EXT_VERSION)

.PHONY: format build install

format:
	@npx prettier --write .

build: format
	@echo "Packaging $(EXT_NAME) $(EXT_VERSION) -> $(VSIX_FILE)"
	@mkdir -p "$(BUILD_DIR)"
	@npx @vscode/vsce package --out "$(VSIX_FILE)"
	@echo "VSIX created at $(VSIX_FILE)"

install: build
	@echo "Installing $(EXT_NAME) $(EXT_VERSION) to $(INSTALL_PATH)"
	@mkdir -p "$(VSCODE_EXTENSIONS_DIR)"
	@rm -rf "$(INSTALL_PATH)"
	@rsync -a \
		--exclude '.git/' \
		--exclude '.github/' \
		--exclude 'node_modules/' \
		--exclude '.vscode/' \
		--exclude 'Makefile' \
		--exclude '$(BUILD_DIR)/' \
		--exclude '*.vsix' \
		./ "$(INSTALL_PATH)"
	@echo "Done. Restart VS Code to pick up the theme."
