.PHONY: help setup install install-python install-go install-settings install-keymaps install-all update pull deploy clean

help:
	@echo "Sublime Text Configuration - Available Commands:"
	@echo ""
	@echo "Setup:"
	@echo "  make setup            - Configure paths for this machine"
	@echo ""
	@echo "Install (individual):"
	@echo "  make install-python   - Install Python snippets"
	@echo "  make install-go       - Install Go snippets"
	@echo "  make install-settings - Install settings files"
	@echo "  make install-keymaps  - Install keymaps"
	@echo ""
	@echo "Install (combined):"
	@echo "  make install          - Install Python snippets (legacy)"
	@echo "  make install-all      - Install everything (snippets, settings, keymaps)"
	@echo ""
	@echo "Git operations:"
	@echo "  make update           - Install all + commit + push changes"
	@echo "  make pull             - Pull updates and install all"
	@echo "  make deploy           - Same as update (alias)"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean            - Remove .sublime-config file"
	@echo ""

setup:
	./scripts/setup-config.sh

install-python:
	./scripts/install-python-snippets.sh

install-go:
	./scripts/install-go-snippets.sh

install-settings:
	./scripts/install-settings.sh

install-keymaps:
	./scripts/install-keymaps.sh

install: install-python

install-all: install-python install-go install-settings install-keymaps
	@echo ""
	@echo "✓ All configurations installed!"

update: install-all
	@echo "Committing and pushing changes..."
	git add .
	git commit -m "Update configurations"
	git push

pull:
	git pull
	$(MAKE) install-all

deploy: update

clean:
	rm -f .sublime-config
	@echo "Removed .sublime-config - run 'make setup' to reconfigure"
