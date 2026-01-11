.PHONY: help setup install update pull deploy clean

help:
	@echo "Sublime Text Configuration - Available Commands:"
	@echo ""
	@echo "  make setup    - Configure paths for this machine"
	@echo "  make install  - Install Python snippets to Sublime"
	@echo "  make update   - Install + commit + push changes"
	@echo "  make pull     - Pull updates and install"
	@echo "  make deploy   - Same as update (alias)"
	@echo "  make clean    - Remove .sublime-config file"
	@echo ""

setup:
	./scripts/setup-config.sh

install:
	./scripts/install-python-snippets.sh

update: install
	@echo "Committing and pushing changes..."
	git add .
	git commit -m "Update snippets"
	git push

pull:
	git pull
	./scripts/install-python-snippets.sh

deploy: update

clean:
	rm -f .sublime-config
	@echo "Removed .sublime-config - run 'make setup' to reconfigure"
