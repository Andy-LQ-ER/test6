# your-project-name

> Short description of your project.

This repository is a **Python project template** — a pre-configured starting point that includes automated testing, code quality checks, security scanning, and GitHub repository settings. Instead of spending days setting all of this up from scratch for every new project, you clone this template and get everything out of the box.

---

## Table of Contents

1. [Before You Begin — Install the Prerequisites](#1-before-you-begin--install-the-prerequisites)
2. [Use This as a Template on GitHub](#2-use-this-as-a-template-on-github)
3. [Clone and Set Up Your New Repo](#3-clone-and-set-up-your-new-repo)
4. [Rename the Package to Your Project Name](#4-rename-the-package-to-your-project-name)
5. [Set Up Environment Variables](#5-set-up-environment-variables)
6. [Initialize the Secrets Baseline](#6-initialize-the-secrets-baseline)
7. [Apply GitHub Repository Settings with Terraform](#7-apply-github-repository-settings-with-terraform)
8. [Your First Commit and Pull Request](#8-your-first-commit-and-pull-request)
9. [Day-to-Day Development Commands](#9-day-to-day-development-commands)
10. [What Every File and Folder Does](#10-what-every-file-and-folder-does)
11. [How the CI Pipeline Works](#11-how-the-ci-pipeline-works)
12. [Frequently Asked Questions](#12-frequently-asked-questions)

---

## 1. Before You Begin — Install the Prerequisites

These are the tools you need installed on your computer before anything else. Each one only needs to be installed once — not for every project.

### Git

Git is version control software. It tracks every change you make to your code, lets you go back in time, and lets multiple people collaborate. GitHub is a website that hosts Git repositories.

- **Windows:** Download from https://git-scm.com/download/win and run the installer. Accept all defaults.
- **Mac:** Run `xcode-select --install` in Terminal.
- **Verify it works:** Open a terminal and run `git --version`. You should see something like `git version 2.43.0`.

### Python 3.12 or newer

Python is the programming language this template is built for.

- Download from https://www.python.org/downloads/ — click the big "Download Python 3.x.x" button.
- **Windows:** During installation, check the box that says **"Add Python to PATH"** — this is critical.
- **Verify it works:** Run `python --version`. You should see `Python 3.12.x` or newer.

### uv — Python Package Manager

`uv` is a modern, fast tool for managing Python dependencies (the libraries your project needs). It replaces older tools like `pip` and `virtualenv`.

```bash
# Mac / Linux:
curl -LsSf https://astral.sh/uv/install.sh | sh

# Windows (run in PowerShell):
powershell -ExecutionPolicy BypassScope -c "irm https://astral.sh/uv/install.ps1 | iex"
```

- **Verify it works:** Run `uv --version`. You should see something like `uv 0.5.x`.

### Terraform (for GitHub repo settings — optional for local dev)

Terraform is a tool for managing infrastructure (including GitHub repository settings) using configuration files instead of clicking through the GitHub UI. You only need this when creating a new repo from this template.

- Download from https://developer.hashicorp.com/terraform/install — pick your operating system.
- **Windows:** Extract the `.zip` and put `terraform.exe` somewhere on your PATH (e.g. `C:\Windows\System32`).
- **Verify it works:** Run `terraform --version`.

### GitHub CLI (optional but useful)

The GitHub CLI lets you interact with GitHub from your terminal.

- Download from https://cli.github.com/
- After installing, run `gh auth login` and follow the prompts to connect it to your GitHub account.

---

## 2. Use This as a Template on GitHub

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

## 3. Clone and Set Up Your New Repo

"Cloning" means downloading a copy of your GitHub repository to your local computer so you can work on it.

**Open a terminal** (Command Prompt, PowerShell, or Terminal on Mac), then run:

```bash
# Replace YOUR-USERNAME and YOUR-REPO-NAME with your actual values
git clone https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git

# Move into the project folder
cd YOUR-REPO-NAME

# Install all Python dependencies and set up the pre-commit hooks
make install-dev
```

What `make install-dev` does:
- Downloads all Python libraries the project needs (into a hidden `.venv` folder)
- Installs pre-commit hooks — small scripts that run automatically every time you make a commit to catch problems early

> **What is a virtual environment (`.venv`)?** It is an isolated folder that contains the Python packages for this specific project. This keeps projects from interfering with each other. You never need to manually activate it — `uv run` handles that automatically.

---

## 4. Rename the Package to Your Project Name

The source code lives inside `src/your_package/`. You need to rename this folder to match your project.

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

---

## 5. Set Up Environment Variables

Environment variables are settings that your application reads at runtime — things like API keys, database URLs, or feature flags. They are kept outside of the code so you never accidentally commit a secret to GitHub.

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

**Important:** The `.env` file is listed in `.gitignore`, which means Git will never include it in commits. The `.env.example` file (with placeholder values) IS committed so that teammates know which variables they need — but it never contains real secrets.

---

## 6. Initialize the Secrets Baseline

This project uses a tool called `detect-secrets` that scans your code before every commit to make sure you haven't accidentally included a password, API key, or other secret.

The "baseline" is a snapshot of any known/intentional patterns in your codebase so the tool knows what to ignore. It needs to be generated once and committed to the repo.

```bash
# Generate the baseline (run this from the project root)
uv run detect-secrets scan > .secrets.baseline
```

Then commit it:

```bash
git add .secrets.baseline
git commit -m "chore: initialize secrets baseline"
```

If the tool ever flags something as a potential secret, you have two choices:
- Fix the code to remove the secret, OR
- If it's a false positive (not actually a secret), update the baseline: `uv run detect-secrets scan --baseline .secrets.baseline`

---

## 7. Apply GitHub Repository Settings with Terraform

The `terraform/` folder contains configuration that sets up your GitHub repository's settings automatically — things like branch protection rules, required code reviews before merging, and issue labels. This is the second part of the setup and only needs to be done once per new repo.

### Step 1: Create a GitHub Personal Access Token

Terraform needs permission to configure your GitHub repo. You give it this permission with a Personal Access Token (PAT).

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

> `terraform.tfvars` is listed in `.gitignore` — it will never be committed because it contains your token.

### Step 3: Run Terraform

```bash
# Still inside the terraform/ folder:

# Download the GitHub Terraform provider
terraform init

# Preview what changes will be made (no changes applied yet)
terraform plan

# Apply the changes to GitHub
terraform apply
```

Type `yes` when prompted. Terraform will:
- Configure the repo's merge settings (squash merge only, auto-delete branches)
- Set up branch protection on `main` (requires PR + CI to pass before merge)
- Create standard issue labels (bug, enhancement, dependencies, etc.)

---

## 8. Your First Commit and Pull Request

With everything set up, the standard workflow for making changes is:

1. **Create a branch** — never commit directly to `main`:
   ```bash
   git checkout -b feature/my-new-feature
   ```

2. **Write your code** in `src/your_package/`

3. **Run checks locally** before pushing:
   ```bash
   make all-checks
   ```

4. **Commit your changes:**
   ```bash
   git add src/your_package/my_new_file.py
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

## 9. Day-to-Day Development Commands

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

## 10. What Every File and Folder Does

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

A `Makefile` is a file full of labelled shell commands. Running `make test` is just a shortcut for the longer `uv run pytest tests/ -v` command. It makes common tasks easy to remember and consistent across the team. You do not need to understand the internals — just use the commands listed in the [Development Commands](#9-day-to-day-development-commands) section.

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

Contains infrastructure-as-code for setting up GitHub repository settings. Instead of clicking through the GitHub UI every time you create a new repo, you fill in a config file and run `terraform apply`. See [Section 7](#7-apply-github-repository-settings-with-terraform) for the full walkthrough.

| File | Purpose |
|---|---|
| `main.tf` | Defines the repo settings, branch protection rules, and issue labels |
| `variables.tf` | Declares the input variables (token, repo name, etc.) |
| `outputs.tf` | Prints the repo URL after setup |
| `terraform.tfvars.example` | Template for your personal config — copy to `terraform.tfvars` |

### `Makefile`

See [Development Commands](#9-day-to-day-development-commands).

---

## 11. How the CI Pipeline Works

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

## 12. Frequently Asked Questions

**Q: I ran `make install-dev` and got an error about `uv` not being found.**
A: `uv` is not installed or not on your PATH. Follow the installation steps in [Section 1](#1-before-you-begin--install-the-prerequisites). On Windows, you may need to restart your terminal after installation.

**Q: My commit was blocked by a pre-commit hook. What do I do?**
A: Read the error message — it tells you exactly what the problem is and often which file and line. The `ruff` and `ruff-format` hooks usually auto-fix issues, so just run `git add .` and `git commit` again. If `detect-secrets` flags something, see [Section 6](#6-initialize-the-secrets-baseline).

**Q: CI is failing on GitHub but my local checks pass. Why?**
A: The most common cause is a dependency that is installed locally but not in `pyproject.toml`. Make sure everything your code needs is listed under `dependencies` in `pyproject.toml`.

**Q: Do I need to run Terraform every time I make a code change?**
A: No. Terraform is a one-time setup per repository. It configures GitHub settings (branch protection, labels, etc.) — not your code. Run it once when you create a new repo from this template.

**Q: What is the difference between `make lint` and `make format`?**
A: `lint` checks for code quality issues — unused imports, potential bugs, security problems — and reports them. `format` changes the visual layout of your code (indentation, spacing, line breaks) to match a consistent style. You typically run format first, then lint.

**Q: I see "Coverage" percentages in the test output. What does that mean?**
A: Code coverage measures what percentage of your source code is actually run during your tests. 100% means every line is tested. Lower numbers mean some code paths are untested and could have hidden bugs. Aim for above 80%.

---

## License

