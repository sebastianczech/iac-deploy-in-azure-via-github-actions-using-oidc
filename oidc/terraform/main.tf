# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config
data "azuread_client_config" "current" {}

# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application
resource "azuread_application" "auth" {
  display_name     = var.app_name
  sign_in_audience = "AzureADMyOrg"
}

# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal
resource "azuread_service_principal" "sp" {
  client_id                    = azuread_application.auth.client_id
  app_role_assignment_required = false
}

# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal_password
resource "azuread_service_principal_password" "pass" {
  service_principal_id = azuread_service_principal.sp.id
}

# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_federated_identity_credential
resource "azuread_application_federated_identity_credential" "github" {
  application_id = azuread_application.auth.id
  display_name   = "github-actions"
  description    = "GitHub Actions OIDC"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_repo}:ref:refs/heads/${var.github_branch}"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
resource "azurerm_role_assignment" "sp_role" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.sp.object_id
}
