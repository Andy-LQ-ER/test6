#!/usr/bin/env bash
set -euo pipefail

# Only run once — marker file is written on successful completion
MARKER=".devcontainer/.initialized"
if [ -f "$MARKER" ]; then
    echo "✓ Project already initialized, skipping setup."
    exit 0
fi

# Guard against a partial previous run (folder already renamed but script didn't finish)
if [ ! -d "src/your_package" ]; then
    echo "⚠ It looks like setup ran partially before (src/your_package is already renamed)."
    echo "  Complete the remaining steps manually:"
    echo ""
    echo "    uv run detect-secrets scan > .secrets.baseline"
    echo "    git add -A"
    echo "    git commit -m \"chore: initialize project from template\""
    echo "    touch $MARKER"
    echo ""
    exit 1
fi

echo ""
echo "============================================"
echo "  First-time project setup"
echo "============================================"
echo ""

read -rp "Project name (kebab-case, e.g. invoice-parser): " PROJECT_NAME
read -rp "Short description: " DESCRIPTION
read -rp "Author name: " AUTHOR_NAME
read -rp "Author email: " AUTHOR_EMAIL
read -rp "GitHub username (for CODEOWNERS): " GITHUB_USERNAME

# Convert kebab-case to snake_case for the Python package name
PACKAGE_NAME="${PROJECT_NAME//-/_}"

echo ""
echo "Setting up '$PROJECT_NAME' (package: '$PACKAGE_NAME')..."

# 1. Rename the package folder
mv "src/your_package" "src/${PACKAGE_NAME}"

# 2. Update all files using Python (safe with special characters)
export PROJECT_NAME PACKAGE_NAME DESCRIPTION AUTHOR_NAME AUTHOR_EMAIL GITHUB_USERNAME
python3 - <<'PYEOF'
import os

PROJECT_NAME   = os.environ["PROJECT_NAME"]
PACKAGE_NAME   = os.environ["PACKAGE_NAME"]
DESCRIPTION    = os.environ["DESCRIPTION"]
AUTHOR_NAME    = os.environ["AUTHOR_NAME"]
AUTHOR_EMAIL   = os.environ["AUTHOR_EMAIL"]
GITHUB_USERNAME = os.environ["GITHUB_USERNAME"]

def patch(path, replacements):
    with open(path) as f:
        content = f.read()
    for old, new in replacements:
        content = content.replace(old, new)
    with open(path, "w") as f:
        f.write(content)

# pyproject.toml
patch("pyproject.toml", [
    ('name = "your-project-name"',                   f'name = "{PROJECT_NAME}"'),
    ('description = "Your project description"',     f'description = "{DESCRIPTION}"'),
    ('{ name = "Your Name", email = "you@example.com" }',
                                                     f'{{ name = "{AUTHOR_NAME}", email = "{AUTHOR_EMAIL}" }}'),
    ('known-first-party = ["your_package"]',         f'known-first-party = ["{PACKAGE_NAME}"]'),
    ('packages = ["src/your_package"]',              f'packages = ["src/{PACKAGE_NAME}"]'),
])

# src/<package>/__init__.py
patch(f"src/{PACKAGE_NAME}/__init__.py", [
    ("your_package — replace with your package description",
     f"{PACKAGE_NAME} — {DESCRIPTION}"),
])

# tests/test_example.py
patch("tests/test_example.py", [
    ("from your_package import", f"from {PACKAGE_NAME} import"),
])

# CODEOWNERS
patch("CODEOWNERS", [
    ("@your-username", f"@{GITHUB_USERNAME}"),
])

# README.md — just the title and subtitle lines
patch("README.md", [
    ("# your-project-name\n", f"# {PROJECT_NAME}\n"),
    ("> Short description of your project.\n", f"> {DESCRIPTION}\n"),
])

print("✓ Files updated")
PYEOF

# 3. Copy .env.example → .env (skip if already exists)
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo "✓ Created .env (fill in your values)"
fi

# 4. Regenerate secrets baseline
uv run detect-secrets scan > .secrets.baseline
echo "✓ Secrets baseline regenerated"

# 5. Trust this directory (dev containers mount workspace as a different owner)
git config --global --add safe.directory "$(pwd)"

# 6. Set git identity (uses provided values; harmless if already set)
git config user.name  "${AUTHOR_NAME}"  2>/dev/null || true
git config user.email "${AUTHOR_EMAIL}" 2>/dev/null || true

# 7. Write completion marker (before commit so it's included)
touch "$MARKER"

# 8. Normalize the default branch name to 'master'
git branch -M master

# 9. Initial commit
git add -A
git commit -m "chore: initialize project from template"
echo "✓ Initial commit created"

echo ""
echo "✓ Setup complete! Next steps:"
echo "   • Fill in your secrets in .env"
echo "   • Run 'make all-checks' to verify everything works"
echo "   • Run Terraform once to apply GitHub repo settings (see README §7)"
echo ""
