#!/bin/bash
#
# setup-config.sh
# Interactive script to create .sublime-config file
#

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
CONFIG_FILE="$REPO_DIR/.sublime-config"
EXAMPLE_FILE="$REPO_DIR/.sublime-config.example"

echo -e "${BLUE}Sublime Text Configuration Setup${NC}"
echo "=================================="
echo ""

# Detect OS and suggest default path
detect_default_path() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        echo "$HOME/Library/Application Support/Sublime Text/Packages/User"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        echo "$HOME/.config/sublime-text-3/Packages/User"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        # Windows (Git Bash)
        echo "$APPDATA/Sublime Text 3/Packages/User"
    else
        echo ""
    fi
}

DEFAULT_PATH=$(detect_default_path)

# Check if config already exists
if [ -f "$CONFIG_FILE" ]; then
    echo -e "${YELLOW}Config file already exists at:${NC}"
    echo "$CONFIG_FILE"
    echo ""
    source "$CONFIG_FILE"
    echo -e "${YELLOW}Current configuration:${NC}"
    echo "SUBLIME_USER_DIR=\"$SUBLIME_USER_DIR\""
    echo ""
    read -p "Do you want to reconfigure? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Configuration unchanged."
        exit 0
    fi
    echo ""
fi

# Prompt for directory
echo "Please enter the path to your Sublime Text User directory."
echo ""

if [ -n "$DEFAULT_PATH" ]; then
    echo -e "${BLUE}Detected path for your OS:${NC}"
    echo "$DEFAULT_PATH"
    echo ""

    # Check if default path exists
    if [ -d "$DEFAULT_PATH" ]; then
        echo -e "${GREEN}✓ This directory exists!${NC}"
        read -p "Use this path? (Y/n): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            SUBLIME_USER_DIR="$DEFAULT_PATH"
        fi
    else
        echo -e "${YELLOW}⚠ This directory does not exist on your system.${NC}"
        read -p "Use this path anyway? (y/N): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            SUBLIME_USER_DIR="$DEFAULT_PATH"
        fi
    fi
fi

# If not set yet, prompt for custom path
if [ -z "$SUBLIME_USER_DIR" ]; then
    echo "Enter custom path (or press Enter to use default):"
    read -r CUSTOM_PATH

    if [ -n "$CUSTOM_PATH" ]; then
        SUBLIME_USER_DIR="$CUSTOM_PATH"
    else
        SUBLIME_USER_DIR="$DEFAULT_PATH"
    fi
fi

# Validate the path
echo ""
echo -e "${BLUE}Validating path...${NC}"

if [ -d "$SUBLIME_USER_DIR" ]; then
    echo -e "${GREEN}✓ Directory exists: $SUBLIME_USER_DIR${NC}"
else
    echo -e "${YELLOW}⚠ Warning: Directory does not exist: $SUBLIME_USER_DIR${NC}"
    echo "Make sure Sublime Text is installed before running install scripts."
fi

# Create config file
echo ""
echo "Creating configuration file..."

cat > "$CONFIG_FILE" << EOF
# Sublime Text Configuration
# This file is git-ignored and specific to your machine

# Path to Sublime Text User directory
SUBLIME_USER_DIR="$SUBLIME_USER_DIR"
EOF

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ Configuration saved to: $CONFIG_FILE${NC}"
    echo ""
    echo -e "${BLUE}Configuration:${NC}"
    echo "SUBLIME_USER_DIR=\"$SUBLIME_USER_DIR\""
    echo ""
    echo -e "${GREEN}You can now run installation scripts!${NC}"
    echo ""
    echo "Example:"
    echo "  ./scripts/install-python-snippets.sh"
else
    echo -e "${RED}✗ Failed to create configuration file${NC}"
    exit 1
fi
