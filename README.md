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

```bash
cd oidc/terraform

terraform init
terraform apply
```

## Define secrets in GitHub repository

![](images/github-secrets.png)
