#!/bin/bash
#
# install-settings.sh
# Installs Sublime Text settings from this repo to Sublime Text 3's User directory
#

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Paths
REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
SETTINGS_SOURCE="$REPO_DIR/settings"
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

echo -e "${BLUE}Sublime Text Settings Installer${NC}"
echo "================================"
echo ""
echo "Source:      $SETTINGS_SOURCE"
echo "Destination: $SUBLIME_USER"
echo ""

# Check if source directory exists
if [ ! -d "$SETTINGS_SOURCE" ]; then
    echo -e "${RED}Error: Source directory not found: $SETTINGS_SOURCE${NC}"
    exit 1
fi

# Check if Sublime User directory exists
if [ ! -d "$SUBLIME_USER" ]; then
    echo -e "${RED}Error: Sublime Text User directory not found: $SUBLIME_USER${NC}"
    echo "Make sure Sublime Text is installed."
    exit 1
fi

# Count settings files
SETTINGS_COUNT=$(find "$SETTINGS_SOURCE" -name "*.sublime-settings" | wc -l | tr -d ' ')

if [ "$SETTINGS_COUNT" -eq 0 ]; then
    echo -e "${RED}Error: No settings files found in $SETTINGS_SOURCE${NC}"
    exit 1
fi

echo -e "${BLUE}Found $SETTINGS_COUNT settings file(s) to install${NC}"
echo ""

# Copy settings
echo "Copying settings..."
cp "$SETTINGS_SOURCE"/*.sublime-settings "$SUBLIME_USER/"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ Successfully installed $SETTINGS_COUNT settings file(s)!${NC}"
    echo ""
    echo "Installed settings:"
    find "$SETTINGS_SOURCE" -name "*.sublime-settings" -exec basename {} \; | sort
    echo ""
    echo -e "${BLUE}Note: Restart Sublime Text for settings to take effect.${NC}"
else
    echo -e "${RED}✗ Installation failed${NC}"
    exit 1
fi
