variable "github_token" {
  description = "GitHub personal access token with repo and admin:repo_hook scopes"
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "GitHub username or organisation name"
  type        = string
}

variable "repo_name" {
  description = "Repository name"
  type        = string
}

variable "repo_description" {
  description = "Repository description"
  type        = string
  default     = ""
}

variable "repo_visibility" {
  description = "Repository visibility: public or private"
  type        = string
  default     = "private"

  validation {
    condition     = contains(["public", "private"], var.repo_visibility)
    error_message = "Must be 'public' or 'private'."
  }
}

variable "default_branch" {
  description = "The default branch to protect (main or master)"
  type        = string
  default     = "master"

  validation {
    condition     = contains(["main", "master"], var.default_branch)
    error_message = "Must be 'main' or 'master'."
  }
}

variable "required_status_checks" {
  description = "CI job names that must pass before a PR can merge"
  type        = list(string)
  default = [
    "Lint Code Base",
    "Test",
  ]
}
