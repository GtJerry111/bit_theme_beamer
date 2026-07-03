#!/bin/bash
# install-resources.sh — Install BIT theme resources into the user's TeX tree.
# Usage: ./scripts/install-resources.sh
# This allows \pgfdeclareimage to find resources via TEXINPUTS without copying
# the resources/ directory into every project.

set -euo pipefail

TEXMF_HOME="${TEXMF_HOME:-$HOME/texmf}"
RESOURCES_DIR="$(cd "$(dirname "$0")/../resources" && pwd)"
TARGET_DIR="$TEXMF_HOME/tex/latex/bit-beamer-theme/resources"

echo "Installing BIT theme resources..."
mkdir -p "$TARGET_DIR"
cp "$RESOURCES_DIR"/*.png "$TARGET_DIR/"
cp "$RESOURCES_DIR"/*.pdf "$TARGET_DIR/" 2>/dev/null || true

# Also install image/ directory
IMAGE_DIR="$(cd "$(dirname "$0")/../image" && pwd)"
TARGET_IMAGE_DIR="$TEXMF_HOME/tex/latex/bit-beamer-theme/image"
mkdir -p "$TARGET_IMAGE_DIR"
cp "$IMAGE_DIR"/*.pdf "$TARGET_IMAGE_DIR/" 2>/dev/null || true

echo "Resources installed to $TARGET_DIR"
echo "Run 'mktexlsr' to update the TeX file database (may require sudo)."
