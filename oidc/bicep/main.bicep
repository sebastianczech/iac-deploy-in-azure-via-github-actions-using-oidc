extension microsoftGraphV1

targetScope = 'subscription'

@description('Name of the Azure AD application')
param appName string

@description('GitHub repository in format owner/repo')
param githubRepo string

@description('GitHub branch name')
param githubBranch string

var githubOIDCProvider = 'https://token.actions.githubusercontent.com'
var microsoftEntraAudience = 'api://AzureADTokenExchange'
var gitHubActionsFederatedIDentitySubject = 'repo:${githubRepo}:ref:refs/heads/${githubBranch}'

resource application 'Microsoft.Graph/applications@v1.0' = {
  uniqueName: appName
  displayName: appName
  signInAudience: 'AzureADMyOrg'

  resource githubFederatedIdentityCredential 'federatedIdentityCredentials@v1.0' = {
    name: '${application.uniqueName}/github-actions'
    audiences: [
      microsoftEntraAudience
    ]
    issuer: githubOIDCProvider
    subject: gitHubActionsFederatedIDentitySubject
  }
}

resource servicePrincipal 'Microsoft.Graph/servicePrincipals@v1.0' = {
  appId: application.appId
}

output clientId string = application.appId
output subscriptionId string = subscription().subscriptionId
output tenantId string = tenant().tenantId
output displayName string = application.displayName
output objectId string = servicePrincipal.id
