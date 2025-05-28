targetScope = 'subscription'

@description('Name of the Azure AD application')
param appName string

@description('GitHub repository in format owner/repo')
param githubRepo string

@description('GitHub branch name')
param githubBranch string

resource application 'Microsoft.AzureActiveDirectory/applications@2021-09-30' = {
  name: appName
  properties: {
    signInAudience: 'AzureADMyOrg'
  }
}

resource servicePrincipal 'Microsoft.AzureActiveDirectory/servicePrincipals@2021-09-30' = {
  name: application.name
  properties: {
    appId: application.properties.appId
    appRoleAssignmentRequired: false
  }
}

resource federatedCredential 'Microsoft.AzureActiveDirectory/applications/federatedIdentityCredentials@2021-09-30' = {
  name: 'github-actions'
  parent: application
  properties: {
    description: 'GitHub Actions OIDC'
    audiences: [
      'api://AzureADTokenExchange'
    ]
    issuer: 'https://token.actions.githubusercontent.com'
    subject: 'repo:${githubRepo}:ref:refs/heads/${githubBranch}'
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, servicePrincipal.id, 'Reader')
  properties: {
    principalId: servicePrincipal.id
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'acdd72a7-3385-48ef-bd42-f606fba81ae7'
    ) // Reader role
    principalType: 'ServicePrincipal'
  }
}
