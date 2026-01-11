#!/bin/bash
#
# install-go-snippets.sh
# Installs Go snippets from this repo to Sublime Text 3's User directory
#

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Paths
REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
SNIPPETS_SOURCE="$REPO_DIR/snippets/go"
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

echo -e "${BLUE}Go Snippets Installer${NC}"
echo "================================"
echo ""
echo "Source:      $SNIPPETS_SOURCE"
echo "Destination: $SUBLIME_USER"
echo ""

# Check if source directory exists
if [ ! -d "$SNIPPETS_SOURCE" ]; then
    echo -e "${RED}Error: Source directory not found: $SNIPPETS_SOURCE${NC}"
    exit 1
fi

# Check if Sublime User directory exists
if [ ! -d "$SUBLIME_USER" ]; then
    echo -e "${RED}Error: Sublime Text User directory not found: $SUBLIME_USER${NC}"
    echo "Make sure Sublime Text is installed."
    exit 1
fi

# Count snippets
SNIPPET_COUNT=$(find "$SNIPPETS_SOURCE" -name "*.sublime-snippet" | wc -l | tr -d ' ')

if [ "$SNIPPET_COUNT" -eq 0 ]; then
    echo -e "${RED}Error: No snippets found in $SNIPPETS_SOURCE${NC}"
    exit 1
fi

echo -e "${BLUE}Found $SNIPPET_COUNT Go snippet(s) to install${NC}"
echo ""

# Copy snippets
echo "Copying snippets..."
cp "$SNIPPETS_SOURCE"/*.sublime-snippet "$SUBLIME_USER/"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ Successfully installed $SNIPPET_COUNT Go snippets!${NC}"
    echo ""
    echo "Installed snippets:"
    find "$SNIPPETS_SOURCE" -name "*.sublime-snippet" -exec basename {} \; | sort
    echo ""
    echo -e "${BLUE}Note: Restart Sublime Text for snippets to take effect.${NC}"
    echo -e "${BLUE}Type snippets in any Go file: main, iferr, test, boiler, httpreq${NC}"
else
    echo -e "${RED}✗ Installation failed${NC}"
    exit 1
fi
