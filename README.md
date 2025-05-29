# Deploy IaC in Azure via GitHub actions using OIDC

This repository demonstrates how to deploy infrastructure using Terraform & Bicep to Azure through GitHub Actions, leveraging OpenID Connect (OIDC) for secure authentication.

## Overview

Integration between Azure and GitHub uses [OpenID Connect in Azure](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure), which works with Azure's [workload identity federation](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation).

### Architecture

```mermaid
C4Context
    title Architecture - GitHub Actions with OIDC Authentication to Azure

    Enterprise_Boundary(b0, "Authentication Flow") {
        Person(developer, "Developer", "Pushes code to repository")

        System_Boundary(b1, "GitHub") {
            System(repo, "GitHub Repository", "Contains IaC code")
            System(actions, "GitHub Actions", "CI/CD Pipeline")
        }

        System_Boundary(b2, "Azure") {
            System(oidc, "OIDC Provider", "Identity Federation")
            System(app_reg, "App Registration", "Service Principal")
            System(azure_res, "Azure Resources", "Infrastructure")
        }
    }

    Rel(developer, repo, "Push code", "git push")
    UpdateRelStyle(developer, repo, $textColor="green", $lineColor="green")

    Rel(repo, actions, "Trigger workflow", "on: push")
    UpdateRelStyle(repo, actions, $textColor="blue", $lineColor="blue")

    Rel(actions, oidc, "Request token", "JWT")
    UpdateRelStyle(actions, oidc, $textColor="orange", $lineColor="orange")

    Rel(oidc, app_reg, "Validate claims", "OIDC")
    UpdateRelStyle(oidc, app_reg, $textColor="orange", $lineColor="orange")

    Rel(actions, azure_res, "Deploy infrastructure", "with OIDC token")
    UpdateRelStyle(actions, azure_res, $textColor="red", $lineColor="red")
```

## Key resources

- [Configure OIDC provider in Azure](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-azure) - sets up the OIDC provider in Azure to trust GitHub Actions
- [Subject claims for access control](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/about-security-hardening-with-openid-connect#example-subject-claims) - allows restricting access tokens to specific branches, environments or events

## Create app registration and service principal

### Prerequisites

```bash
az login
```

### Bicep

```bash
cd oidc/bicep

az deployment sub what-if \
  --location westeurope \
  --name oidc-bicep \
  --template-file main.bicep \
  --parameters parameters.json

az deployment sub create \
  --location westeurope \
  --name oidc-bicep \
  --template-file main.bicep \
  --parameters parameters.json
```

Links:
* [Bicep best practices](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/best-practices)
* [Example - subscription role assignment](https://github.com/Azure/azure-quickstart-templates/blob/master/subscription-deployments/subscription-role-assignment/main.bicep)
* [Role assignments in Bicep](https://learn.microsoft.com/en-gb/azure/templates/microsoft.authorization/roleassignments?pivots=deployment-language-bicep)
* [Quickstart: Create and deploy your first Bicep file with Microsoft Graph resources](https://learn.microsoft.com/en-gb/graph/templates/bicep/quickstart-create-bicep-interactive-mode?tabs=CLI)
* [msgraph-bicep-types - quickstart-templates](https://github.com/microsoftgraph/msgraph-bicep-types/tree/main/quickstart-templates)
* [Configure federated identity credential for GitHub Actions](https://github.com/microsoftgraph/msgraph-bicep-types/blob/main/quickstart-templates/create-fic-for-github-actions/README.md)

### Terraform

```bash
cd oidc/terraform

terraform init
terraform apply
```

## Define secrets in GitHub repository

![](images/github-secrets.png)
