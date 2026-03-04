# test6

> test

This repository is a **Python project template** — a pre-configured starting point that includes automated testing, code quality checks, security scanning, and GitHub repository settings. Instead of spending days setting all of this up from scratch for every new project, you clone this template and get everything out of the box.

---

## Table of Contents

1. [Use This as a Template on GitHub](#1-use-this-as-a-template-on-github)
2. [Choose Your Setup Path](#2-choose-your-setup-path)
3. [Path A — Dev Container (Recommended)](#3-path-a--dev-container-recommended)
4. [Path B — Manual Setup](#4-path-b--manual-setup)
5. [Apply GitHub Repository Settings with Terraform](#5-apply-github-repository-settings-with-terraform)
6. [Your First Commit and Pull Request](#6-your-first-commit-and-pull-request)
7. [Day-to-Day Development Commands](#7-day-to-day-development-commands)
8. [What Every File and Folder Does](#8-what-every-file-and-folder-does)
9. [How the CI Pipeline Works](#9-how-the-ci-pipeline-works)
10. [Frequently Asked Questions](#10-frequently-asked-questions)
11. [Extending CodeRabbit for New Folders](#11-extending-coderabbit-for-new-folders)
12. [Regular Maintenance Plan](#12-regular-maintenance-plan)

---

## 1. Use This as a Template on GitHub

This repo is set up as a **GitHub Template Repository**, which means GitHub has a special button to create a fresh copy of it under your own account — without copying the commit history.

**Steps:**

1. Go to this repository on GitHub.
2. Click the green **"Use this template"** button near the top right.
3. Click **"Create a new repository"**.
4. Give your new repo a name (e.g. `my-new-project`).
5. Choose **Private** or **Public**.
6. Click **"Create repository"**.

You now have your own copy of the template under your GitHub account.

> **Note:** Do not click "Fork". Forking is for contributing back to the original repo. "Use this template" gives you a clean, independent copy.

---

## 2. Choose Your Setup Path

There are two ways to set up your new repo. Pick the one that suits you:

| | Path A — Dev Container | Path B — Manual |
|---|---|---|
| **What you need** | Docker + VS Code + Dev Containers extension | Git, Python 3.12, uv |
| **Setup effort** | Answer 5 prompts — everything else is automatic | Run several commands manually |
| **Environment** | Isolated container, identical for all teammates | Your local machine |
| **Recommended if** | You want the fastest start and consistent environments | You prefer working directly on your machine |

---

## 3. Path A — Dev Container (Recommended)

The dev container automatically installs all tools, dependencies, and pre-commit hooks, then runs a one-time setup script that renames the package and configures your project. You only need to answer a few prompts.

### Prerequisites

Install these once on your machine:

- **Docker Desktop** — [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
- **VS Code** — [code.visualstudio.com](https://code.visualstudio.com)
- **Dev Containers extension** — install from the VS Code Extensions panel (`ms-vscode-remote.remote-containers`)

### Steps

1. Clone your new repo and open it in VS Code:
   ```bash
   git clone https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git
   code YOUR-REPO-NAME
   ```

2. VS Code will detect the `.devcontainer` folder and show a notification — click **"Reopen in Container"**. (Or open the Command Palette with `Ctrl+Shift+P` / `Cmd+Shift+P` and run **"Dev Containers: Reopen in Container"**.)

3. Wait for the container to build. The first time takes a few minutes. You will see progress in the terminal panel.

4. Once the container is ready, open the VS Code terminal and run the one-time setup script:
   ```bash
   bash .devcontainer/setup.sh
   ```
   Answer the prompts:
   ```
   Project name (kebab-case, e.g. invoice-parser): my-project
   Short description: What this project does
   Author name: Your Name
   Author email: you@example.com
   GitHub username (for CODEOWNERS): your-github-username
   ```

5. The script handles the rest — see below.

### What the dev container does automatically

| Step | Handled automatically |
|---|---|
| Install Python 3.12, Node.js, uv | ✓ |
| Install all Python dependencies | ✓ (`uv sync --all-groups`) |
| Install pre-commit hooks | ✓ |
| Install Claude Code CLI | ✓ |
| Configure VS Code extensions and settings | ✓ |

### What the setup script does (step 4 above)

| Step | Handled by `setup.sh` |
|---|---|
| Rename `src/your_package/` to your package name | ✓ |
| Update all references in `pyproject.toml`, tests, `CODEOWNERS`, `README.md` | ✓ |
| Copy `.env.example` → `.env` | ✓ |
| Regenerate secrets baseline | ✓ |
| Make initial commit | ✓ |

### Remaining manual steps after running the setup script

1. **Fill in your `.env` file** — the file was created for you, but the actual secret values (API keys, database URLs, etc.) must be entered by hand.

2. **Apply GitHub repository settings with Terraform** (optional, one-time) — see [Section 5](#5-apply-github-repository-settings-with-terraform).

---

## 4. Path B — Manual Setup

Use this path if you prefer to work directly on your local machine without Docker.

### Prerequisites

Install these once on your machine:

#### Git

- **Windows:** Download from https://git-scm.com/download/win and run the installer. Accept all defaults.
- **Mac:** Run `xcode-select --install` in Terminal.
- **Verify:** `git --version`

#### Python 3.12 or newer

- Download from https://www.python.org/downloads/
- **Windows:** During installation, check **"Add Python to PATH"** — this is critical.
- **Verify:** `python --version`

#### uv — Python Package Manager

`uv` is a modern, fast tool for managing Python dependencies. It replaces older tools like `pip` and `virtualenv`.

```bash
# Mac / Linux:
curl -LsSf https://astral.sh/uv/install.sh | sh

# Windows (run in PowerShell):
powershell -ExecutionPolicy BypassScope -c "irm https://astral.sh/uv/install.ps1 | iex"
```

- **Verify:** `uv --version`

#### Terraform (optional — for GitHub repo settings)

Only needed when running the one-time GitHub repo setup in [Section 5](#5-apply-github-repository-settings-with-terraform).

- Download from https://developer.hashicorp.com/terraform/install
- **Windows:** Extract the `.zip` and put `terraform.exe` somewhere on your PATH (e.g. `C:\Windows\System32`).
- **Verify:** `terraform --version`

#### GitHub CLI (optional but useful)

- Download from https://cli.github.com/
- After installing, run `gh auth login` and follow the prompts.

### Clone and set up your new repo

```bash
# Replace YOUR-USERNAME and YOUR-REPO-NAME with your actual values
git clone https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git
cd YOUR-REPO-NAME

# Install all Python dependencies and set up the pre-commit hooks
make install-dev
```

> **What is a virtual environment (`.venv`)?** It is an isolated folder that contains the Python packages for this specific project. You never need to manually activate it — `uv run` handles that automatically.

### Rename the package to your project name

The source code lives inside `src/your_package/`. Rename this folder to match your project.

**Example:** If your project is called `invoice-parser`, rename it to `invoice_parser` (Python package names use underscores, not hyphens).

```
src/
└── your_package/     ← rename this folder
    └── __init__.py
```

After renaming, update three places in [pyproject.toml](pyproject.toml):

```toml
# Line 2 — the project name (hyphens are fine here)
name = "invoice-parser"

# Line 89 — the package name for import sorting (must match the folder name)
known-first-party = ["invoice_parser"]

# Line 112 — tells the build tool where your package lives
packages = ["src/invoice_parser"]
```

Also update the import in [tests/test_example.py](tests/test_example.py):

```python
# Change this line:
from your_package import __version__
# To:
from invoice_parser import __version__
```

### Set up environment variables

```bash
# Copy the example file to create your real .env file
cp .env.example .env
```

Open `.env` in any text editor and fill in your values:

```
ENV=development
API_KEY=your-actual-key-here
DATABASE_URL=postgresql://localhost/mydb
```

**Important:** The `.env` file is listed in `.gitignore` and will never be committed. The `.env.example` file (with placeholder values) IS committed so teammates know which variables they need.

### Initialize the secrets baseline

`detect-secrets` scans your code before every commit to catch accidentally included secrets. The baseline needs to be generated once and committed.

```bash
uv run detect-secrets scan > .secrets.baseline
git add .secrets.baseline
git commit -m "chore: initialize secrets baseline"
```

If the tool ever flags something as a potential secret:
- Fix the code to remove the secret, OR
- If it is a false positive: `uv run detect-secrets scan --baseline .secrets.baseline`

---

## 5. Apply GitHub Repository Settings with Terraform

This step applies branch protection rules, required code reviews, and issue labels to your GitHub repository. It is **optional for local development** but recommended before you start merging pull requests.

**This only needs to be done once per new repo, regardless of which setup path you used.**

### Step 1: Create a GitHub Personal Access Token

1. Go to GitHub → click your profile photo → **Settings**
2. Scroll to the bottom left → **Developer settings**
3. **Personal access tokens** → **Tokens (classic)**
4. Click **"Generate new token (classic)"**
5. Give it a name like `terraform-repo-setup`
6. Set expiration to **30 days** (you only need it once)
7. Check these scopes: **`repo`** (all) and **`delete_repo`**
8. Click **"Generate token"** and copy it immediately — you won't see it again

### Step 2: Create your tfvars file

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Open `terraform.tfvars` and fill in your values:

```hcl
github_token      = "ghp_your_token_here"
github_owner      = "your-github-username"
repo_name         = "your-repo-name"
repo_description  = "What this project does"
repo_visibility   = "private"
```

> `terraform.tfvars` is listed in `.gitignore` — it will never be committed.

### Step 3: Run Terraform

```bash
# Still inside the terraform/ folder:
terraform init    # Download the GitHub Terraform provider
terraform plan    # Preview changes (nothing applied yet)
terraform apply   # Apply the changes to GitHub
```

Type `yes` when prompted. Terraform will:
- Configure merge settings (squash merge only, auto-delete branches)
- Set up branch protection on `main` (requires PR + CI to pass before merge)
- Create standard issue labels (bug, enhancement, dependencies, etc.)

---

## 6. Your First Commit and Pull Request

With everything set up, the standard workflow for making changes is:

1. **Create a branch** — never commit directly to `main`:
   ```bash
   git checkout -b feature/my-new-feature
   ```

2. **Write your code** in `src/<your_package>/`

3. **Run checks locally** before pushing:
   ```bash
   make all-checks
   ```

4. **Commit your changes:**
   ```bash
   git add src/<your_package>/my_new_file.py
   git commit -m "feat: add my new feature"
   ```
   The pre-commit hooks run automatically here. If they catch an issue, fix it and commit again.

5. **Push to GitHub:**
   ```bash
   git push origin feature/my-new-feature
   ```

6. **Open a Pull Request** on GitHub. The PR template will appear automatically with a checklist to fill in. The CI pipeline will run automatically and you'll see green checkmarks (or red Xs) on the PR.

7. **Get a review** (if CODEOWNERS is configured) and merge once CI passes.

---

## 7. Day-to-Day Development Commands

All common tasks have shortcuts via `make`. Run `make help` to see the full list.

| Command | What it does |
|---|---|
| `make install-dev` | Install all dependencies + pre-commit hooks (run once after cloning) |
| `make test` | Run all tests |
| `make test-cov` | Run tests and show which lines of code are not covered by tests |
| `make lint` | Check code style and catch common bugs (does not fix anything) |
| `make lint-fix` | Automatically fix lint issues where possible |
| `make format` | Auto-format code to a consistent style |
| `make format-check` | Check formatting without changing files (used in CI) |
| `make security-check` | Scan your source code for security vulnerabilities |
| `make all-checks` | Run lint + format-check + tests + security in one go |
| `make clean` | Delete temporary files and caches |
| `make pre-commit-run` | Manually run all pre-commit hooks on every file |

---

## 8. What Every File and Folder Does

### `src/your_package/`

This is where your actual Python code lives. The `src/` layout (putting your package inside a `src/` folder) is a best practice that prevents accidental imports of your local code instead of the installed version.

- `__init__.py` — marks the folder as a Python package and defines `__version__`. Every Python package needs this file.

### `tests/`

This is where your test files live. Tests are separate Python scripts that verify your code behaves correctly. The convention is to name test files `test_*.py` and test functions `test_*`.

- `test_example.py` — a starter test. Replace its contents with real tests for your code.
- `__init__.py` — marks this folder as a package (required for pytest to discover tests correctly).

### `pyproject.toml`

The single configuration file for your entire Python project. It replaces what used to be spread across `setup.py`, `setup.cfg`, `requirements.txt`, and separate config files for every tool. It defines:

- **Project metadata** — name, version, description, authors, Python version requirement
- **Dependencies** — the libraries your project needs to run, and dev-only tools
- **Ruff settings** — which code style rules to enforce
- **Mypy settings** — how strict the type checking should be
- **Pytest settings** — where to find tests, which options to use by default
- **Build settings** — how to package the project for distribution

### `Makefile`

A `Makefile` is a file full of labelled shell commands. Running `make test` is just a shortcut for the longer `uv run pytest tests/ -v` command. It makes common tasks easy to remember and consistent across the team. You do not need to understand the internals — just use the commands listed in the [Development Commands](#7-day-to-day-development-commands) section.

### `.pre-commit-config.yaml`

Pre-commit hooks are scripts that run automatically every time you run `git commit`. If any of them fail, the commit is blocked until you fix the problem. This catches issues before they ever reach GitHub.

The hooks configured here are:

| Hook | What it catches |
|---|---|
| `trailing-whitespace` | Removes invisible trailing spaces from lines |
| `end-of-file-fixer` | Makes sure every file ends with a newline |
| `check-yaml` / `check-json` / `check-toml` | Validates config file syntax |
| `check-merge-conflict` | Blocks commits that still have `<<<<<<` conflict markers |
| `check-added-large-files` | Blocks files larger than 1MB being committed accidentally |
| `detect-private-key` | Blocks commits containing private key patterns |
| `ruff` | Runs the linter and auto-fixes issues |
| `ruff-format` | Formats code to a consistent style |
| `detect-secrets` | Scans for accidentally included API keys, passwords, tokens |

### `.secrets.baseline`

This is the "known good" snapshot used by the `detect-secrets` hook. When the tool scans your code and finds something that looks like a secret, it checks this file first. If the item is already in the baseline, it's treated as an acknowledged false positive and ignored. Commit this file — it does not contain actual secrets, only patterns and hashes.

### `.github/workflows/ci.yml`

This file defines the **CI (Continuous Integration) pipeline** — automated checks that run on GitHub every time you push code or open a pull request. You do not run this manually; GitHub runs it automatically in the cloud.

The pipeline has two jobs that run in parallel:

**Lint job:**
- Runs **Super-Linter** — a comprehensive linter that checks Python style (ruff), type hints (mypy), YAML/JSON/Markdown syntax, and GitHub Actions syntax
- Runs **Trivy** — scans your dependencies for known security vulnerabilities
- Runs **Gitleaks** — scans the entire git history for accidentally committed secrets

**Test job:**
- Installs Python and all dependencies using `uv`
- Runs your test suite with `pytest`
- Runs `bandit` — a security linter that looks for common Python security mistakes in your source code

If any step fails, GitHub shows a red X on the pull request and blocks merging (once branch protection is configured via Terraform).

### `.github/dependabot.yml`

Dependabot is a GitHub bot that automatically opens pull requests to update your dependencies when new versions are released. It runs weekly and creates PRs with the label `dependencies`. You review, check that CI passes, and merge — keeping your project up to date with minimal effort.

It is configured to watch:
- **Python packages** — updates in `pyproject.toml` / `uv.lock`
- **GitHub Actions** — updates the `uses: actions/...@v4` version pins in your workflows

### `.github/pull_request_template.md`

When someone opens a pull request on GitHub, this file's content is automatically pre-filled into the PR description box. It guides the author to describe what they changed, why, and confirm they tested it. This makes code reviews faster and more consistent.

### `.github/ISSUE_TEMPLATE/`

These files provide structured forms when someone creates a new GitHub Issue. Instead of a blank text box, reporters see specific fields to fill in:

- `bug_report.md` — asks for steps to reproduce, expected vs actual behaviour, and environment details
- `feature_request.md` — asks for the problem being solved, the proposed solution, and alternatives considered

### `CODEOWNERS`

This file tells GitHub who should automatically be requested as a reviewer when a pull request is opened. The syntax is:

```
*                    @your-username     ← @your-username reviews all files
.github/workflows/   @your-username     ← especially sensitive CI changes
```

Update `@your-username` to your actual GitHub username (or a team like `@your-org/backend-team`).

### `.coderabbit.yaml`

CodeRabbit is an AI-powered code review tool that automatically reviews pull requests and leaves comments. This config file customises its behaviour:

- Sets the review tone to "assertive" (direct and focused)
- Focuses on security, credentials, and business logic for `.py` files
- Focuses on secret exposure and permissions for workflow files
- Skips reviewing lock files and cache directories

CodeRabbit is free for public repos. For private repos you need to connect it at https://coderabbit.ai.

### `.env.example`

A template showing which environment variables your application needs. This file IS committed to git (it has no real values), so teammates can see what variables they need to set up. Copy it to `.env` and fill in real values. `.env` is gitignored and never committed.

### `.gitignore`

A list of file patterns that Git should completely ignore — they will never appear in commits or on GitHub. Common examples:

- `__pycache__/`, `*.pyc` — Python's compiled bytecode (auto-generated, not needed)
- `.venv/` — your local virtual environment (reproducible from `pyproject.toml`, huge folder)
- `.env` — contains real secrets
- `htmlcov/`, `.coverage` — test coverage reports (generated locally, not needed in git)
- `.DS_Store` — macOS folder metadata (useless to everyone else)
- `terraform/terraform.tfvars` — contains your GitHub token

### `.gitattributes`

Tells Git how to handle line endings. Different operating systems use different characters to represent "end of line":
- Windows uses `CRLF` (`\r\n`)
- Mac/Linux uses `LF` (`\n`)

This mismatch causes files to appear "changed" when they haven't actually changed meaningfully. The setting `* text=auto eol=lf` tells Git to always store and check out files with LF line endings, keeping things consistent across all platforms.

### `terraform/`

Contains infrastructure-as-code for setting up GitHub repository settings. Instead of clicking through the GitHub UI every time you create a new repo, you fill in a config file and run `terraform apply`. See [Section 5](#5-apply-github-repository-settings-with-terraform) for the full walkthrough.

| File | Purpose |
|---|---|
| `main.tf` | Defines the repo settings, branch protection rules, and issue labels |
| `variables.tf` | Declares the input variables (token, repo name, etc.) |
| `outputs.tf` | Prints the repo URL after setup |
| `terraform.tfvars.example` | Template for your personal config — copy to `terraform.tfvars` |

### `.devcontainer/devcontainer.json`

Configures the VS Code dev container environment — the base Docker image, VS Code extensions, editor settings, and the commands that run when the container is first created. See [Section 3](#3-path-a--dev-container-recommended) for details.

### `.devcontainer/setup.sh`

The one-time initialization script that runs automatically inside the dev container on first open. It prompts for your project details, renames the package, updates all config files, and makes an initial commit. It is idempotent — if the project is already initialized it exits immediately.

---

## 9. How the CI Pipeline Works

Here is what happens from the moment you push code to GitHub:

```
You push code  →  GitHub detects the push
                         ↓
              Two jobs start simultaneously:
              ┌────────────────┐  ┌────────────┐
              │   Lint job     │  │  Test job  │
              │                │  │            │
              │  Super-Linter  │  │  pytest    │
              │  (ruff, mypy,  │  │  bandit    │
              │  yaml, etc.)   │  │            │
              │  Trivy scan    │  │            │
              │  Gitleaks scan │  │            │
              └───────┬────────┘  └─────┬──────┘
                      │                 │
                      └────────┬────────┘
                               ↓
                    All green? → PR can be merged
                    Any red?   → PR is blocked
```

Branch protection (configured by Terraform) ensures that:
- No one can push directly to `main` — all changes must go through a PR
- The PR cannot be merged until both CI jobs pass
- At least 1 person has reviewed and approved the code
- The branch is up to date with `main` before merging

---

## 10. Frequently Asked Questions

**Q: I ran `make install-dev` and got an error about `uv` not being found.**
A: `uv` is not installed or not on your PATH. Follow the installation steps in [Section 4 — Prerequisites](#4-path-b--manual-setup). On Windows, you may need to restart your terminal after installation.

**Q: My commit was blocked by a pre-commit hook. What do I do?**
A: Read the error message — it tells you exactly what the problem is and often which file and line. The `ruff` and `ruff-format` hooks usually auto-fix issues, so just run `git add .` and `git commit` again. If `detect-secrets` flags something, regenerate the baseline: `uv run detect-secrets scan --baseline .secrets.baseline`.

**Q: CI is failing on GitHub but my local checks pass. Why?**
A: The most common cause is a dependency that is installed locally but not in `pyproject.toml`. Make sure everything your code needs is listed under `dependencies` in `pyproject.toml`.

**Q: Do I need to run Terraform every time I make a code change?**
A: No. Terraform is a one-time setup per repository. It configures GitHub settings (branch protection, labels, etc.) — not your code. Run it once when you create a new repo from this template.

**Q: What is the difference between `make lint` and `make format`?**
A: `lint` checks for code quality issues — unused imports, potential bugs, security problems — and reports them. `format` changes the visual layout of your code (indentation, spacing, line breaks) to match a consistent style. You typically run format first, then lint.

**Q: I see "Coverage" percentages in the test output. What does that mean?**
A: Code coverage measures what percentage of your source code is actually run during your tests. 100% means every line is tested. Lower numbers mean some code paths are untested and could have hidden bugs. Aim for above 80%.

**Q: The dev container setup script ran but I want to re-run it. How?**
A: The script only runs once (it checks for `src/your_package/` as a signal). If you need to rename things again after initialization, update the relevant files manually — `pyproject.toml`, `CODEOWNERS`, and the `src/` folder.

---

## 11. Extending CodeRabbit for New Folders

The `.coderabbit.yaml` file already configures CodeRabbit to review all `.py` files, tests, workflow files, and `pyproject.toml`. When you add new folders to your project, you can give CodeRabbit folder-specific instructions so its reviews are more relevant and focused.

### How to add a new path rule

Open `.coderabbit.yaml` and add a new entry under `path_instructions`:

```yaml
reviews:
  path_instructions:
    - path: "**/*.py"
      instructions: >
        Focus on: security vulnerabilities, credential/secret exposure ...  # existing rule

    # Add your new rule below:
    - path: "src/my_feature/**"
      instructions: >
        Describe what matters for this folder — e.g. domain-specific rules,
        things to never do, security concerns, or patterns to enforce.

    - path: "migrations/**"
      instructions: >
        Check that migrations are reversible (have a downgrade path), do not
        drop columns without a deprecation period, and do not perform
        long-running table locks on large tables.
```

CodeRabbit reads this file fresh on every PR — no restart or reconnection needed. Commit the change and it takes effect immediately.

### Tips for writing good path instructions

- **Be specific to the domain.** Generic advice ("write clean code") adds no value. Tell it what matters for that folder.
- **Mention what NOT to do.** "Never use float for currency" is more actionable than "be careful with numbers".
- **Rules stack.** A file matching both `**/*.py` and `src/my_feature/**` gets both sets of instructions applied.
- **Skip noisy folders.** Add an entry under `path_filters` to exclude auto-generated files you don't want reviewed:

```yaml
  path_filters:
    - "!**/*.lock"
    - "!.venv/**"
    - "!**/__pycache__/**"
    - "!migrations/versions/**"   # skip auto-generated migration files
```

---

## 12. Regular Maintenance Plan

Keeping a project healthy means keeping its tools up to date. This template has two update mechanisms: **Dependabot** handles most things automatically, and a few tasks require a **manual sync** to prevent version drift between local tools and CI.

---

### Automatic — Dependabot (weekly)

Dependabot opens pull requests every week to update:
- Python packages declared in `pyproject.toml` (e.g. `pytest`, `pre-commit`)
- GitHub Actions version pins in `.github/workflows/ci.yml` (e.g. `actions/checkout`, `astral-sh/setup-uv`)

**What to do:** Review the Dependabot PR, check that CI passes, and merge. No manual work needed.

> **Exception:** Dependabot will bump `ruff` in `pyproject.toml`, but it cannot simultaneously update the `ruff-pre-commit` hook in `.pre-commit-config.yaml` or the Super-Linter pin in `ci.yml`. Follow the manual sync steps below whenever a Dependabot ruff or mypy PR arrives.

---

### Manual — Tool version sync (when Dependabot opens a ruff or mypy PR)

Because ruff and mypy must be identical in three places (Super-Linter, `pyproject.toml`, and `.pre-commit-config.yaml`), updates require a coordinated manual step.

**When triggered by a ruff Dependabot PR:**

1. Find a Super-Linter release that bundles the new ruff version:
   - Check [`dependencies/python/ruff.txt`](https://github.com/super-linter/super-linter/blob/main/dependencies/python/ruff.txt) for the version pinned in the latest Super-Linter release.
   - If Super-Linter has not yet caught up to the new ruff version, wait or stay on the current version.

2. Update all three files together:

   | File | What to change |
   |---|---|
   | `.github/workflows/ci.yml` | `super-linter/super-linter@vX.Y.Z` → new version |
   | `pyproject.toml` | `ruff==X.Y.Z` → version bundled in that Super-Linter release |
   | `.pre-commit-config.yaml` | `rev: vX.Y.Z` under `ruff-pre-commit` → same version |

3. Run `make all-checks` locally to confirm nothing broke, then commit all three files in a single commit.

**When triggered by a mypy Dependabot PR:**

1. Check [`dependencies/python/mypy.txt`](https://github.com/super-linter/super-linter/blob/main/dependencies/python/mypy.txt) in the Super-Linter release you are targeting.
2. If Super-Linter bundles the same mypy version, bump `mypy==X.Y.Z` in `pyproject.toml` and `super-linter/super-linter@vX.Y.Z` in `ci.yml` together.
3. Run `uv run mypy src/` locally to confirm no regressions, then commit.

---

### Manual — Python version bump (as needed, ~yearly)

When a new Python minor version is released and stable:

1. Update the base image in `.devcontainer/devcontainer.json`:
   ```
   mcr.microsoft.com/devcontainers/python:1-3.12-bullseye
                                             ^^^^
   ```
2. Update `requires-python` in `pyproject.toml`:
   ```toml
   requires-python = ">=3.13"
   ```
3. Update `target-version` in `[tool.ruff]`:
   ```toml
   target-version = "py313"
   ```
4. Update `python_version` in `[tool.mypy]`:
   ```toml
   python_version = "3.13"
   ```
5. Update the matrix in `.github/workflows/ci.yml`:
   ```yaml
   python-version: ["3.13"]
   ```
6. Run the full test suite and fix any compatibility issues.

---

### Summary table

| What | How often | Who | Action |
|---|---|---|---|
| Python packages (`pytest`, etc.) | Weekly | Dependabot (automatic PR) | Review + merge |
| GitHub Actions versions | Weekly | Dependabot (automatic PR) | Review + merge |
| ruff version | When new version desired | Manual | Sync `pyproject.toml`, `.pre-commit-config.yaml`, and `ci.yml` (Super-Linter) together |
| mypy version | When new version desired | Manual | Sync `pyproject.toml` and `ci.yml` (Super-Linter) together |
| Python version | ~Yearly | Manual | Update 5 files — see steps above |

---

## License
