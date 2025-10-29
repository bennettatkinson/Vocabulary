#!/bin/bash

# Installation script for Vocabulary Quiz man page and TLDR documentation
# This script installs the vocabularyquiz.1 man page and TLDR.txt to standard Linux locations

set -e

echo "========================================="
echo "Vocabulary Quiz Installation Script"
echo "========================================="
echo ""

# Check if running with sudo/root
if [[ $EUID -ne 0 ]]; then
   echo "❌ This script must be run with sudo"
   echo "Usage: sudo bash install-docs.sh"
   exit 1
fi

# Define source files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAN_SOURCE="$SCRIPT_DIR/vocabularyquiz.man"
TLDR_SOURCE="$SCRIPT_DIR/TLDR.txt"

# Define destination directories
MAN_DEST="/usr/share/man/man1/vocabularyquiz.1"
TLDR_DEST="/usr/local/share/tldr/vocabularyquiz.txt"
TLDR_ALT_DEST="/usr/share/tldr/vocabularyquiz.txt"

# Check if source files exist
if [[ ! -f "$MAN_SOURCE" ]]; then
    echo "❌ Error: vocabularyquiz.man not found at $MAN_SOURCE"
    exit 1
fi

if [[ ! -f "$TLDR_SOURCE" ]]; then
    echo "❌ Error: TLDR.txt not found at $TLDR_SOURCE"
    exit 1
fi

echo "✓ Source files found"
echo ""

# Install man page
echo "Installing man page..."
mkdir -p /usr/share/man/man1
cp "$MAN_SOURCE" "$MAN_DEST"
chmod 644 "$MAN_DEST"
echo "✓ Man page installed to $MAN_DEST"

# Update man database
echo ""
echo "Updating man database..."
if command -v mandb &> /dev/null; then
    mandb -q 2>/dev/null || true
    echo "✓ Man database updated"
else
    echo "⚠ mandb not found, skipping database update"
fi

# Install TLDR file
echo ""
echo "Installing TLDR documentation..."

# Try primary location first
if mkdir -p /usr/local/share/tldr 2>/dev/null; then
    cp "$TLDR_SOURCE" "$TLDR_DEST"
    chmod 644 "$TLDR_DEST"
    echo "✓ TLDR installed to $TLDR_DEST"
else
    # Fallback to alternative location
    mkdir -p /usr/share/tldr
    cp "$TLDR_SOURCE" "$TLDR_ALT_DEST"
    chmod 644 "$TLDR_ALT_DEST"
    echo "✓ TLDR installed to $TLDR_ALT_DEST"
fi

echo ""
echo "========================================="
echo "Installation Complete!"
echo "========================================="
echo ""
echo "You can now access the documentation with:"
echo "  man vocabularyquiz"
echo "  cat /usr/local/share/tldr/vocabularyquiz.txt"
echo ""
echo "To view the man page:"
echo "  man vocabularyquiz.ps1"
echo "or"
echo "  man vocabularyquiz"
echo ""
