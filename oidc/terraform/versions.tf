terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.4.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.30.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "azuread" {
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
