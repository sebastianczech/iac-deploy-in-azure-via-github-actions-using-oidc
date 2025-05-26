output "client_id" {
  description = "Client ID of the Azure AD application (use as AZURE_CLIENT_ID in GitHub secrets)"
  value       = azuread_application.auth.client_id
}

output "tenant_id" {
  description = "Tenant ID of the Azure AD application (use as AZURE_TENANT_ID in GitHub secrets)"
  value       = data.azuread_client_config.current.tenant_id
}

output "application_name" {
  description = "Display name of the Azure AD application"
  value       = azuread_application.auth.display_name
}

output "federated_credential_id" {
  description = "ID of the federated credential created for GitHub Actions"
  value       = azuread_application_federated_identity_credential.github.id
}

output "github_oidc_config" {
  description = "GitHub OIDC configuration details"
  value = {
    issuer  = "https://token.actions.githubusercontent.com"
    subject = "repo:${var.github_repo}"
  }
}
