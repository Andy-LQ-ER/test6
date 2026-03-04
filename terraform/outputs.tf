output "repo_url" {
  description = "GitHub repository URL"
  value       = github_repository.repo.html_url
}

output "repo_full_name" {
  description = "Full repository name (owner/repo)"
  value       = github_repository.repo.full_name
}
