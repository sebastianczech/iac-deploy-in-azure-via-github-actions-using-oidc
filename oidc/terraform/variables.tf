variable "app_name" {
  description = "The display name for the OIDC application"
  type        = string
  default     = "oidc-tf"
}

variable "github_repo" {
  description = "GitHub repository in the format 'owner/repo'"
  type        = string
  default     = "sebastianczech/iac-deploy-in-azure-via-github-actions-using-oidc"
}

variable "github_branch" {
  description = "GitHub branch name"
  type        = string
  default     = "main"
}

variable "subscription_id" {
  description = "The Azure subscription ID where the role assignment will be created"
  type        = string
}
