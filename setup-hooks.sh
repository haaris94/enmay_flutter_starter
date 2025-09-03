#!/bin/bash
# Setup git hooks for cross-platform Flutter development

echo "Setting up git hooks for Flutter development..."

# Create .git/hooks directory if it doesn't exist
mkdir -p .git/hooks

# Copy hooks from .hooks directory to .git/hooks
cp .hooks/pre-commit .git/hooks/pre-commit
cp .hooks/post-merge .git/hooks/post-merge

# Make hooks executable
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/post-merge

echo "✅ Git hooks installed successfully!"
echo ""
echo "Hooks installed:"
echo "  - pre-commit: Generates code and formats before commits"
echo "  - post-merge: Updates dependencies and generates code after pulls"
echo ""
echo "To disable hooks temporarily, use: git commit --no-verify"