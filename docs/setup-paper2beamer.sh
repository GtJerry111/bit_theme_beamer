#!/bin/bash
# Setup script for paper2beamer integration
# This script creates a symbolic link so that paper2beamer can use the BIT ISA
# from this repository without manual synchronization.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BIT_ISA="$REPO_ROOT/isa/BIT.yaml"

# Default paper2beamer ISA directory
PAPER2BEAMER_ISA="${PAPER2BEAMER_ISA:-$HOME/.cc-switch/skills/paper2beamer/isa}"

echo "BIT Beamer Theme - paper2beamer Setup"
echo "======================================"
echo ""
echo "Repository root: $REPO_ROOT"
echo "BIT ISA file:    $BIT_ISA"
echo "Target directory: $PAPER2BEAMER_ISA"
echo ""

# Verify BIT ISA exists
if [ ! -f "$BIT_ISA" ]; then
    echo "Error: BIT ISA file not found at $BIT_ISA"
    exit 1
fi

# Create target directory if it doesn't exist
if [ ! -d "$PAPER2BEAMER_ISA" ]; then
    echo "Creating paper2beamer ISA directory..."
    mkdir -p "$PAPER2BEAMER_ISA"
fi

# Remove existing file/link if present
TARGET="$PAPER2BEAMER_ISA/BIT.yaml"
if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
    echo "Removing existing BIT.yaml..."
    rm -f "$TARGET"
fi

# Create symbolic link
echo "Creating symbolic link..."
ln -s "$BIT_ISA" "$TARGET"

echo ""
echo "✓ Setup complete!"
echo ""
echo "paper2beamer will now automatically use the BIT ISA from this repository."
echo "Any updates to isa/BIT.yaml will be immediately available to paper2beamer."
echo ""
echo "To verify the setup:"
echo "  ls -l $TARGET"
