#!/bin/bash
#
# install-keymaps.sh
# Installs Sublime Text keymaps from this repo to Sublime Text 3's User directory
#

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Paths
REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
KEYMAPS_SOURCE="$REPO_DIR/keymaps"
CONFIG_FILE="$REPO_DIR/.sublime-config"

# Load configuration file if it exists
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
    SUBLIME_USER="$SUBLIME_USER_DIR"
else
    # Fallback to default path
    echo -e "${RED}Warning: Config file not found at $CONFIG_FILE${NC}"
    echo -e "${RED}Using default path. Run 'scripts/setup-config.sh' to configure.${NC}"
    echo ""
    SUBLIME_USER="$HOME/Library/Application Support/Sublime Text/Packages/User"
fi

echo -e "${BLUE}Sublime Text Keymaps Installer${NC}"
echo "================================"
echo ""
echo "Source:      $KEYMAPS_SOURCE"
echo "Destination: $SUBLIME_USER"
echo ""

# Check if source directory exists
if [ ! -d "$KEYMAPS_SOURCE" ]; then
    echo -e "${RED}Error: Source directory not found: $KEYMAPS_SOURCE${NC}"
    exit 1
fi

# Check if Sublime User directory exists
if [ ! -d "$SUBLIME_USER" ]; then
    echo -e "${RED}Error: Sublime Text User directory not found: $SUBLIME_USER${NC}"
    echo "Make sure Sublime Text is installed."
    exit 1
fi

# Count keymap files
KEYMAP_COUNT=$(find "$KEYMAPS_SOURCE" -name "*.sublime-keymap" | wc -l | tr -d ' ')

if [ "$KEYMAP_COUNT" -eq 0 ]; then
    echo -e "${RED}Error: No keymap files found in $KEYMAPS_SOURCE${NC}"
    exit 1
fi

echo -e "${BLUE}Found $KEYMAP_COUNT keymap file(s) to install${NC}"
echo ""

# Copy keymaps
echo "Copying keymaps..."
cp "$KEYMAPS_SOURCE"/*.sublime-keymap "$SUBLIME_USER/"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ Successfully installed $KEYMAP_COUNT keymap file(s)!${NC}"
    echo ""
    echo "Installed keymaps:"
    find "$KEYMAPS_SOURCE" -name "*.sublime-keymap" -exec basename {} \; | sort
    echo ""
    echo -e "${BLUE}Note: Restart Sublime Text for keymaps to take effect.${NC}"
else
    echo -e "${RED}✗ Installation failed${NC}"
    exit 1
fi
