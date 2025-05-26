# Deploy IaC in Azure via GitHub actions using OIDC

Simple repository created to deploy infrastructure using Terraform & Bicep into Azure cloud by GitHub Action using OpenID Connect.

Whole integration between Azure and GitHub was configured using [Configuring OpenID Connect in Azure](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-azure). GitHub's OIDC provider works with Azure's [workload identity federation](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation). Instructions to [configure the OIDC identity provider in Azure can be found in documentation](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure).

## Create app registration and service principal

```bash
cd oidc/terraform

terraform init
terraform apply
```

## Define secrets in GitHub repository

![](images/github-secrets.png)
