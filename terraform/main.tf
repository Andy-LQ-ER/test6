terraform {
  required_version = ">= 1.6"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  # Optional: store state remotely (e.g. Terraform Cloud, S3)
  # backend "s3" { ... }
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

# ---------------------------------------------------------------------------
# Repository
#
# TWO workflows are supported — pick one:
#
# A) CREATE a new repo with Terraform (skip the GitHub template button):
#      terraform apply
#
# B) MANAGE an existing repo (created via the GitHub template button):
#      terraform import github_repository.repo YOUR-REPO-NAME
#      terraform apply
#
# After either workflow, Terraform owns the repo settings and you can
# re-run `terraform apply` any time to enforce the desired state.
# ---------------------------------------------------------------------------

resource "github_repository" "repo" {
  name        = var.repo_name
  description = var.repo_description
  visibility  = var.repo_visibility

  # Merge settings — squash only keeps a clean, linear history
  allow_squash_merge = true
  allow_merge_commit = false
  allow_rebase_merge = false

  # Auto-delete the feature branch after it is merged
  delete_branch_on_merge = true

  has_issues   = true
  has_projects = false
  has_wiki     = false

  # Set to true if you want THIS repo to be a GitHub template repository
  is_template = false

  lifecycle {
    # Prevent accidental deletion of the repo via `terraform destroy`
    prevent_destroy = true
  }
}

# ---------------------------------------------------------------------------
# Branch protection — main
# ---------------------------------------------------------------------------

resource "github_branch_protection" "main" {
  repository_id = github_repository.repo.node_id
  pattern       = var.default_branch

  # All changes must go through a pull request — no direct pushes to main
  required_pull_request_reviews {
    required_approving_review_count = 1
    dismiss_stale_reviews           = true  # Re-request review if new commits are pushed
    require_code_owner_reviews      = true  # CODEOWNERS must approve
  }

  # CI must pass before a PR can be merged
  required_status_checks {
    strict   = true  # Branch must be up to date with main before merge
    contexts = var.required_status_checks
  }

  enforce_admins         = false  # Set true to apply rules to repo admins too
  allows_deletions       = false  # Nobody can delete the main branch
  allows_force_pushes    = false  # No force-pushing to main
  require_signed_commits = false
}

# ---------------------------------------------------------------------------
# Issue labels
# ---------------------------------------------------------------------------

locals {
  labels = {
    "bug"              = { color = "d73a4a", description = "Something isn't working" }
    "enhancement"      = { color = "a2eeef", description = "New feature or request" }
    "dependencies"     = { color = "0075ca", description = "Dependency update" }
    "python"           = { color = "3572A5", description = "Python dependency" }
    "github-actions"   = { color = "000000", description = "GitHub Actions update" }
    "documentation"    = { color = "0075ca", description = "Improvements to docs" }
    "good first issue" = { color = "7057ff", description = "Good for newcomers" }
    "help wanted"      = { color = "008672", description = "Extra attention needed" }
  }
}

resource "github_issue_label" "labels" {
  for_each    = local.labels
  repository  = github_repository.repo.name
  name        = each.key
  color       = each.value.color
  description = each.value.description
}
